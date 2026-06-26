package com.bank.model;

public class User {
    private int id;
    private String name;
    private String email;
    private String password;
    private String accountNumber;
    private double balance;
    private String pin; // 4-digit transaction PIN (stored as SHA-256 hash)

    public User() {}

    public User(int id, String name, String email, String password,
                String accountNumber, double balance, String pin) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.accountNumber = accountNumber;
        this.balance = balance;
        this.pin = pin;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }

    public double getBalance() { return balance; }
    public void setBalance(double balance) { this.balance = balance; }

    public String getPin() { return pin; }
    public void setPin(String pin) { this.pin = pin; }

    // Returns true if user has already set a PIN
    public boolean hasPin() { return pin != null && !pin.isEmpty(); }

    @Override
    public String toString() {
        return "User{id=" + id + ", name='" + name + "', email='" + email +
               "', accountNumber='" + accountNumber + "', balance=" + balance + "}";
    }
}
