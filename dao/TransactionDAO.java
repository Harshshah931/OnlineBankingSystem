package com.bank.dao;

import com.bank.model.Transaction;
import com.bank.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {

    // ─── DEPOSIT ──────────────────────────────────────────────────────────────
    public boolean deposit(String accountNumber, double amount) {
        if (amount <= 0) return false;

        String updateSql = "UPDATE users SET balance = balance + ? WHERE account_number = ?";
        String insertSql = "INSERT INTO transactions (receiver_account, amount, type) VALUES (?, ?, 'DEPOSIT')";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement updatePs = conn.prepareStatement(updateSql);
                 PreparedStatement insertPs = conn.prepareStatement(insertSql)) {

                updatePs.setDouble(1, amount);
                updatePs.setString(2, accountNumber);

                insertPs.setString(1, accountNumber);
                insertPs.setDouble(2, amount);

                if (updatePs.executeUpdate() > 0 && insertPs.executeUpdate() > 0) {
                    conn.commit();
                    return true;
                }
                conn.rollback();
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ─── WITHDRAW ─────────────────────────────────────────────────────────────
    public boolean withdraw(String accountNumber, double amount) {
        if (amount <= 0) return false;

        String checkSql  = "SELECT balance FROM users WHERE account_number = ?";
        String updateSql = "UPDATE users SET balance = balance - ? WHERE account_number = ?";
        String insertSql = "INSERT INTO transactions (sender_account, amount, type) VALUES (?, ?, 'WITHDRAWAL')";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement checkPs  = conn.prepareStatement(checkSql);
                 PreparedStatement updatePs = conn.prepareStatement(updateSql);
                 PreparedStatement insertPs = conn.prepareStatement(insertSql)) {

                checkPs.setString(1, accountNumber);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (!rs.next() || rs.getDouble("balance") < amount) {
                        conn.rollback();
                        return false;
                    }
                }

                updatePs.setDouble(1, amount);
                updatePs.setString(2, accountNumber);

                insertPs.setString(1, accountNumber);
                insertPs.setDouble(2, amount);

                if (updatePs.executeUpdate() > 0 && insertPs.executeUpdate() > 0) {
                    conn.commit();
                    return true;
                }
                conn.rollback();
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ─── TRANSFER ─────────────────────────────────────────────────────────────
    public boolean transferMoney(String sender, String receiver, double amount) {
        if (amount <= 0 || sender.equals(receiver)) return false;

        String checkSql  = "SELECT balance FROM users WHERE account_number = ?";
        String deductSql = "UPDATE users SET balance = balance - ? WHERE account_number = ?";
        String addSql    = "UPDATE users SET balance = balance + ? WHERE account_number = ?";
        String insertSql = "INSERT INTO transactions (sender_account, receiver_account, amount, type) VALUES (?, ?, ?, 'TRANSFER')";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement checkPs  = conn.prepareStatement(checkSql);
                 PreparedStatement deductPs = conn.prepareStatement(deductSql);
                 PreparedStatement addPs    = conn.prepareStatement(addSql);
                 PreparedStatement insertPs = conn.prepareStatement(insertSql)) {

                checkPs.setString(1, sender);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (!rs.next() || rs.getDouble("balance") < amount) {
                        conn.rollback();
                        return false;
                    }
                }

                deductPs.setDouble(1, amount); deductPs.setString(2, sender);
                addPs.setDouble(1, amount);    addPs.setString(2, receiver);
                insertPs.setString(1, sender); insertPs.setString(2, receiver); insertPs.setDouble(3, amount);

                if (deductPs.executeUpdate() > 0 && addPs.executeUpdate() > 0 && insertPs.executeUpdate() > 0) {
                    conn.commit();
                    return true;
                }
                conn.rollback();
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ─── FULL HISTORY ─────────────────────────────────────────────────────────
    public List<Transaction> getTransactionHistory(String accountNumber) {
        String sql = "SELECT * FROM transactions WHERE sender_account = ? OR receiver_account = ? ORDER BY date DESC";
        return queryTransactions(sql, accountNumber, accountNumber);
    }

    // ─── FILTERED HISTORY (mini statement) ────────────────────────────────────
    // type = DEPOSIT | WITHDRAWAL | TRANSFER | null (all)
    // from / to = "yyyy-MM-dd" strings or null
    public List<Transaction> getFilteredTransactions(String accountNumber, String type, String from, String to) {
        List<Transaction> transactions = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT * FROM transactions WHERE (sender_account = ? OR receiver_account = ?)"
        );

        if (type != null && !type.isEmpty())  sql.append(" AND type = ?");
        if (from != null && !from.isEmpty())  sql.append(" AND date >= ?");
        if (to   != null && !to.isEmpty())    sql.append(" AND date <= ?");
        sql.append(" ORDER BY date DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            ps.setString(idx++, accountNumber);
            ps.setString(idx++, accountNumber);
            if (type != null && !type.isEmpty()) ps.setString(idx++, type);
            if (from != null && !from.isEmpty()) ps.setString(idx++, from + " 00:00:00");
            if (to   != null && !to.isEmpty())   ps.setString(idx++, to   + " 23:59:59");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) transactions.add(mapTransaction(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }

    // ─── ADMIN: ALL RECENT TRANSACTIONS ───────────────────────────────────────
    public List<Transaction> getAllTransactions() {
        String sql = "SELECT * FROM transactions ORDER BY date DESC LIMIT 50";
        List<Transaction> transactions = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) transactions.add(mapTransaction(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }

    // ─── ADMIN: TOTAL TRANSACTION COUNT ───────────────────────────────────────
    public int getTotalTransactionCount() {
        String sql = "SELECT COUNT(*) FROM transactions";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ─── HELPERS ──────────────────────────────────────────────────────────────
    private List<Transaction> queryTransactions(String sql, String... params) {
        List<Transaction> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < params.length; i++) ps.setString(i + 1, params[i]);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapTransaction(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Transaction mapTransaction(ResultSet rs) throws SQLException {
        Transaction t = new Transaction();
        t.setTransactionId(rs.getInt("transaction_id"));
        t.setSenderAccount(rs.getString("sender_account"));
        t.setReceiverAccount(rs.getString("receiver_account"));
        t.setAmount(rs.getDouble("amount"));
        t.setType(rs.getString("type"));
        t.setDate(rs.getString("date"));
        return t;
    }
}