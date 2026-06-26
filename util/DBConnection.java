package com.bank.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {
        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/bankdb",
                "root",
                "harshshah"
            );

            System.out.println("DB CONNECTED SUCCESSFULLY ✅");

        } catch (Exception e) {
            System.out.println("DB CONNECTION FAILED ❌");
            e.printStackTrace();
        }

        return con;
    }
}