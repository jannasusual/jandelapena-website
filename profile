<?php
session_start();
include("connection.php");

// Check if the user is logged in
if (!isset($_SESSION['email'])) {
    header("Location: login.php");
    exit();
}

$email = $_SESSION['email']; // Get the logged-in user's email from the session

// Handle profile picture upload
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['profilePicture'])) {
    $targetDirectory = 'uploads/';
    $profilePicturePath = $targetDirectory . basename($_FILES['profilePicture']['name']);

    if (!is_dir($targetDirectory)) {
        mkdir($targetDirectory, 0777, true);
    }

    if (move_uploaded_file($_FILES['profilePicture']['tmp_name'], $profilePicturePath)) {
        $stmt = $conn->prepare("UPDATE user_logins SET profile_picture = ? WHERE email = ?");
        $stmt->bind_param("ss", $profilePicturePath, $email);
        
        if ($stmt->execute()) {
            $_SESSION['upload_success'] = true;
        }
        $stmt->close();
    }
}

// Fetch user's profile picture from the database
$stmt = $conn->prepare("SELECT profile_picture FROM user_logins WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();
$row = $result->fetch_assoc();
$profilePicture = $row['profile_picture'] ? $row['profile_picture'] : 'default-profile.jpg';
$stmt->close();

// Fetch user's account info from the users table
$stmt = $conn->prepare("SELECT firstname, lastname, middle_name, contactnumber, birthdate, age, gender, civil_status, address FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc(); // Fetch the user's info into an associative array
$stmt->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Profile - Barangay Connect</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <link rel="stylesheet" href="header.css">

  <style>
    body {
      background-color: #f8f9fa;
      padding-top: 70px;
    }
    .profile-card {
      max-width: 800px;
      margin: 0 auto;
      padding: 20px;
      background-color: #ffffff;
      border-radius: 8px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    .profile-pic {
      width: 120px;
      height: 120px;
      border-radius: 50%;
      object-fit: cover;
      border: 3px solid #28a745;
      cursor: pointer;
    }
   
    .tab-content {
      padding: 20px;
      border: 1px solid #e9ecef;
      border-radius: 8px;
      background-color: #fff;
    }
    
  </style>
</head>
<body>

<!-- Navbar -->
<nav class="header-section navbar navbar-expand-lg fixed-top">
    <div class="container-fluid">
        <div class="d-flex align-items-center">
          <a href="userdashboards.php"><img src="bconnect_logo.jpg" alt="Logo" class="me-2">
        </a>

        <a class="navbar-brand" href="userdashboards.php">Barangay Connect</a>
            
           
        </div>

        
    </div>
</nav>

<!-- Profile Card Section -->
<div class="container mt-5">
  <div class="profile-card p-4">
    <div class="text-center mb-4">
      <img id="profilePic" src="<?php echo $profilePicture; ?>" alt="Profile Picture" class="profile-pic" data-bs-toggle="modal" data-bs-target="#profilePictureModal">
      <h3 class="mt-3"><?php echo $email; ?></h3>
    </div>

    <!-- Tabs for Profile Sections -->
    <ul class="nav nav-tabs justify-content-center" id="profileTab" role="tablist">
      <li class="nav-item" role="presentation">
        <button class="nav-link active" id="account-tab" data-bs-toggle="tab" data-bs-target="#account" type="button" role="tab" aria-controls="account" aria-selected="true">Account Info</button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="password-tab" data-bs-toggle="tab" data-bs-target="#password" type="button" role="tab" aria-controls="password" aria-selected="false">Change Password</button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="picture-tab" data-bs-toggle="tab" data-bs-target="#picture" type="button" role="tab" aria-controls="picture" aria-selected="false">Profile Picture</button>
      </li>
    </ul>

    <div class="tab-content" id="profileTabContent">
      <!-- Account Info Tab -->
      <div class="tab-pane fade show active" id="account" role="tabpanel" aria-labelledby="account-tab">
        <h4>Account Information</h4>
        <p><strong>First Name:</strong> <?php echo $user['firstname']; ?></p>
        <p><strong>Last Name:</strong> <?php echo $user['lastname']; ?></p>
        <p><strong>Middle Name:</strong> <?php echo $user['middle_name']; ?></p>
        <p><strong>Contact Number:</strong> <?php echo $user['contactnumber']; ?></p>
        <p><strong>Birthdate:</strong> <?php echo $user['birthdate']; ?></p>
        <p><strong>Age:</strong> <?php echo $user['age']; ?></p>
        <p><strong>Gender:</strong> <?php echo $user['gender']; ?></p>
        <p><strong>Civil Status:</strong> <?php echo $user['civil_status']; ?></p>
        <p><strong>Address:</strong> <?php echo $user['address']; ?></p>
      </div>

      <!-- Change Password Tab -->
      <div class="tab-pane fade " id="password" role="tabpanel" aria-labelledby="password-tab">
                <h4>Change Password</h4>
                <form id="changePasswordForm">
                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">Current Password</label>
                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                    </div>
                    <div class="mb-3">
                        <label for="newPass" class="form-label">New Password</label>
                        <input type="password" class="form-control" id="newPass" name="newPassword" required>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPass" class="form-label">Confirm New Password</label>
                        <input type="password" class="form-control" id="confirmPass" name="confirmPassword" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Change Password</button>
                </form>
            </div>
      
              
          

      <!-- Profile Picture Tab -->
      <div class="tab-pane fade" id="picture" role="tabpanel" aria-labelledby="picture-tab">
        <h4>Profile Picture</h4>
        <form id="uploadForm" method="post" enctype="multipart/form-data" class="mt-3">
          <input type="file" class="form-control" id="imageUpload" name="profilePicture" accept="image/*" required>
          <button type="submit" class="btn btn-success mt-2">Upload</button>
        </form>
        <?php if (isset($_SESSION['upload_success']) && $_SESSION['upload_success']): ?>
          <div class="alert alert-success mt-3" id="uploadAlert">Upload successful!</div>
          <?php unset($_SESSION['upload_success']); ?>
        <?php endif; ?>
      </div>
    </div>
  </div>
</div>

<!-- Modal for viewing profile picture -->
<div class="modal fade" id="profilePictureModal" tabindex="-1" aria-labelledby="profilePictureModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="profilePictureModalLabel">Profile Picture</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <img src="<?php echo $profilePicture; ?>" alt="Full Size Profile Picture" class="img-fluid">
      </div>
    </div>
  </div>
</div>

<script>
  const uploadAlert = document.getElementById('uploadAlert');
  if (uploadAlert) {
    setTimeout(() => {
      uploadAlert.style.display = 'none';
    }, 3000);
  }
  
  document.getElementById("changePasswordForm").addEventListener("submit", function (e) {
    e.preventDefault();
    let currentPassword = document.getElementById("currentPassword").value;
    let newPassword = document.getElementById("newPass").value;
    let confirmPassword = document.getElementById("confirmPass").value;

    if (newPassword !== confirmPassword) {
        alert("New password and confirm password do not match.");
        return;
    }

    // AJAX request to PHP
    fetch("change_password.php", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({
            currentPassword: currentPassword,
            newPassword: newPassword,
        }),
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert("Password changed successfully.");
            document.getElementById("changePasswordForm").reset();
        } else {
            alert(data.message);
        }
    })
    .catch(error => console.error("Error:", error));
});
 
    </script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


</body>
</html>
