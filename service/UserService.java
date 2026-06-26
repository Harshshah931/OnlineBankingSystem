package com.bank.service;

import com.bank.dao.TransactionDAO;
import com.bank.dao.UserDAO;
import com.bank.model.Transaction;
import com.bank.model.User;

import java.util.List;

public class UserService {

    private final UserDAO userDAO = new UserDAO();
    private final TransactionDAO transactionDAO = new TransactionDAO();

    public User login(String email, String password) {
        return userDAO.loginUser(email, password);
    }

    public boolean register(User user) {
        return userDAO.registerUser(user);
    }

    public boolean emailExists(String email) {
        return userDAO.emailExists(email);
    }

    // Verifies the 4-digit transaction PIN before deposit/withdraw/transfer
    public boolean verifyPin(String accountNumber, String hashedPin) {
        return userDAO.verifyPin(accountNumber, hashedPin);
    }

    public boolean deposit(String accountNumber, double amount) {
        return transactionDAO.deposit(accountNumber, amount);
    }

    public boolean withdraw(String accountNumber, double amount) {
        return transactionDAO.withdraw(accountNumber, amount);
    }

    public boolean transfer(String sender, String receiver, double amount) {
        return transactionDAO.transferMoney(sender, receiver, amount);
    }

    public boolean changePassword(String accountNumber, String oldPassword, String newPassword) {
        return userDAO.changePassword(accountNumber, oldPassword, newPassword);
    }

    public List<Transaction> getTransactionHistory(String accountNumber) {
        return transactionDAO.getTransactionHistory(accountNumber);
    }

    public List<Transaction> getFilteredTransactions(String accountNumber, String type, String from, String to) {
        return transactionDAO.getFilteredTransactions(accountNumber, type, from, to);
    }

    public List<User> getAllUsers() { return userDAO.getAllUsers(); }
    public double getTotalBalance() { return userDAO.getTotalBalance(); }
    public List<Transaction> getAllTransactions() { return transactionDAO.getAllTransactions(); }
    public int getTotalTransactionCount() { return transactionDAO.getTotalTransactionCount(); }
}
