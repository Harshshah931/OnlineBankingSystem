package com.bank.dao;

import com.bank.model.User;
import com.bank.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // ─── LOGIN ────────────────────────────────────────────────────────────────
    public User loginUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getString("password").equals(password)) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // ─── REGISTER ─────────────────────────────────────────────────────────────
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (name, email, password, account_number, balance, pin) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getAccountNumber());
            ps.setDouble(5, user.getBalance());
            ps.setString(6, user.getPin()); // pin set during registration
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // ─── CHECK DUPLICATE EMAIL ────────────────────────────────────────────────
    public boolean emailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // ─── VERIFY TRANSACTION PIN ───────────────────────────────────────────────
    public boolean verifyPin(String accountNumber, String hashedPin) {
        String sql = "SELECT pin FROM users WHERE account_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPin = rs.getString("pin");
                    return storedPin != null && storedPin.equals(hashedPin);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // ─── CHANGE PASSWORD ──────────────────────────────────────────────────────
    public boolean changePassword(String accountNumber, String oldPassword, String newPassword) {
        String checkSql  = "SELECT password FROM users WHERE account_number = ?";
        String updateSql = "UPDATE users SET password = ? WHERE account_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setString(1, accountNumber);
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next() && rs.getString("password").equals(oldPassword)) {
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setString(1, newPassword);
                        updatePs.setString(2, accountNumber);
                        return updatePs.executeUpdate() > 0;
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // ─── ADMIN: GET ALL USERS ─────────────────────────────────────────────────
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) users.add(mapUser(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return users;
    }

    // ─── ADMIN: TOTAL BALANCE ─────────────────────────────────────────────────
    public double getTotalBalance() {
        String sql = "SELECT SUM(balance) FROM users";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // ─── HELPER: Map ResultSet → User ─────────────────────────────────────────
    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setAccountNumber(rs.getString("account_number"));
        user.setBalance(rs.getDouble("balance"));
        user.setPin(rs.getString("pin")); // load pin into session user
        return user;
    }
}
