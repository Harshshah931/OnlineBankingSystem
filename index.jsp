<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Online Banking System</title>

    <style>
        body {
            font-family: Arial;
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #4facfe, #00f2fe);
        }

        .container {
            text-align: center;
            margin-top: 150px;
        }

        h1 {
            color: white;
            font-size: 40px;
        }

        .btn {
            padding: 12px 25px;
            margin: 10px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
        }

        .login {
            background-color: #28a745;
            color: white;
        }

        .register {
            background-color: #007bff;
            color: white;
        }

        .btn:hover {
            opacity: 0.8;
        }
    </style>
</head>

<body>
    <div class="container">
        <h1>Online Banking System</h1>

        <a href="login.jsp">
            <button class="btn login">Login</button>
        </a>

        <a href="register.jsp">
            <button class="btn register">Register</button>
        </a>
    </div>
</body>
</html>