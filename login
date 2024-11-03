<?php
session_start();
include("connection.php");

// Handle form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Fetch user data from the user_logins table
    $query = "SELECT * FROM user_logins WHERE email = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    // Check if user exists and password matches
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        if (password_verify($password, $row['password'])) {
            $_SESSION['email'] = $row['email'];

            // Check if the user is an admin
            if ($email === "admin@gmail.com") {
                header("Location: admin.php");
            } else {
                header("Location: userdashboards.php");
            }
            exit();
        } else {
            $error_message = "Invalid password.";
        }
    } else {
        $error_message = "No user found with that email.";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Barangay Connect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: #f0f2f5;
            font-family: Arial, sans-serif;
        }
        .login-container {
            background: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
        }
        .login-header {
            margin-bottom: 20px;
            text-align: center;
        }
        .login-header h2 {
            font-weight: bold;
        }
        .form-control {
            height: 50px;
            border-radius: 5px;
        }
        .btn-login {
            background-color: #28a745;
            color: #ffffff;
            font-weight: bold;
            width: 100%;
            height: 50px;
            border-radius: 5px;
        }
        .btn-login:hover {
            background-color: #218838;
        }
        .alert {
            margin-top: 10px;
        }
        .text-center a {
            text-decoration: none;
            color: #28a745;
        }
        .text-center a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-header">
        <h2>Login</h2>
    </div>

    <?php if (isset($error_message)): ?>
        <div class="alert alert-danger"><?php echo $error_message; ?></div>
    <?php endif; ?>

    <form method="POST" action="">
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
        </div>
        <button type="submit" class="btn btn-login">Login</button>
    </form>

    <div class="text-center mt-3">
        <a href="forgot_password.php">Forgot Password?</a> <!-- Forgot Password Link -->
    </div>
    <div class="text-center mt-2">
        <a href="signup.php">Don't have an account? Sign up</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
