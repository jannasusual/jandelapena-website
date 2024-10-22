<?php

include("connection.php");


// Handle form submission   
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $firstname = $_POST['firstname'];
    $lastname = $_POST['lastname'];
    $middle_name = isset($_POST['middle_name']) ? $_POST['middle_name'] : '';
    $email = $_POST['email'];
    $contactnumber = $_POST['contactnumber'];
    $birthdate = isset($_POST['birthdate']) ? $_POST['birthdate'] : '';
    $gender = $_POST['gender'];
    $civil_status = $_POST['civil_status'];
    $purpose = $_POST['purpose'];
    $address = $_POST['address'];

    // Handle the document upload
    if (isset($_FILES['document']) && $_FILES['document']['error'] === UPLOAD_ERR_OK) {
        // Check file size (limit: 2MB)
        if ($_FILES['document']['size'] > 2 * 1024 * 1024) {
            echo "<div class='alert alert-danger'>Error: File size exceeds 2MB limit.</div>";
            exit;
        }

        // Set the target directory and file path
        $targetDirectory = 'uploads/';
        $targetFile = $targetDirectory . basename($_FILES['document']['name']);

        // Ensure the upload directory exists and is writable
        if (!is_dir($targetDirectory)) {
            mkdir($targetDirectory, 0777, true);
        }

        // Move the uploaded file to the target directory
        if (move_uploaded_file($_FILES['document']['tmp_name'], $targetFile)) {
            echo "<div class='alert alert-success'>Document uploaded successfully.</div>";
        } else {
            echo "<div class='alert alert-danger'>Error moving uploaded document.</div>";
            exit;
        }
    } else {
        echo "<div class='alert alert-danger'>Error uploading document: " . $_FILES['document']['error'] . "</div>";
        exit;
    }

    // Calculate age
    $birthDate = new DateTime($birthdate);
    $today = new DateTime('today');
    $age = $birthDate->diff($today)->y;

    // Prepare and bind the SQL statement
    $stmt = $conn->prepare("INSERT INTO users (firstname, lastname, middle_name, email, contactnumber, birthdate, age, gender, civil_status, purpose, address, document) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssssisssss", $firstname, $lastname, $middle_name, $email, $contactnumber, $birthdate, $age, $gender, $civil_status, $purpose, $address, $targetFile);

    // Execute statement
    try {
        if ($stmt->execute()) {
            echo "<div class='alert alert-success'>New record created successfully</div>";
        } else {
            echo "<div class='alert alert-danger'>Error: " . $stmt->error . "</div>";
        }
    } catch (\Throwable $th) {
        echo "<div class='alert alert-danger'>Error: Email already exists </div>";
    }

    $stmt->close();
}

// Close connection
$conn->close();
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up Form</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container col-md-4 mt-5">
        <!-- Centered heading -->
        <h2 class="text-center mb-4">Sign Up Form</h2>

        <form action="" method="post" enctype="multipart/form-data"> <!-- Add enctype for file upload -->
            <div class="mb-3">
                <label for="firstname" class="form-label">First Name:</label>
                <input type="text" id="firstname" name="firstname" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="lastname" class="form-label">Last Name:</label>
                <input type="text" id="lastname" name="lastname" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="middle_name" class="form-label">Middle name:</label>
                <input type="text" id="middle_name" name="middle_name" class="form-control">
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email:</label>
                <input type="email" id="email" name="email" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="contactnumber" class="form-label">Contact Number:</label>
                <input type="text" id="contactnumber" name="contactnumber" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="birthdate" class="form-label">Birthdate:</label>
                <input type="date" id="birthdate" name="birthdate" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="age" class="form-label">Age:</label>
                <input type="number" id="age" name="age" class="form-control" readonly>
            </div>

            <div class="mb-3">
                <label for="gender" class="form-label">Gender:</label>
                <select id="gender" name="gender" class="form-select" required>
                    <option value="" disabled selected>Select your gender</option>
                    <option value="female">Female</option>
                    <option value="male">Male</option>
                </select>
            </div>

            <div class="mb-3">
                <label for="civil_status" class="form-label">Civil Status:</label>
                <select id="civil_status" name="civil_status" class="form-select" required>
                    <option value="" disabled selected>Select your civil status</option>
                    <option value="single">Single</option>
                    <option value="married">Married</option>
                    <option value="divorced">Divorced</option>
                    <option value="widowed">Widowed</option>
                    <option value="separated">Separated</option>
                    <option value="in_a_relationship">In a Relationship</option>
                    <option value="engaged">Engaged</option>
                </select>
            </div>

            <div class="mb-3">
                <label for="address" class="form-label">Address:</label>
                <textarea id="address" name="address" class="form-control" rows="4" required></textarea>
            </div>

            <div class="mb-3">
                <label for="purpose" class="form-label">Purpose:</label>
                <textarea id="purpose" name="purpose" class="form-control" rows="4" required></textarea>
            </div>

            <!-- Document upload -->
            <div class="mb-3">
                <label for="document" class="form-label">Upload Document:</label>
                <input type="file" id="document" name="document" class="form-control" required>
            </div>

            <button type="submit" class="btn btn-primary w-100">Submit</button>
        </form>

        <!-- Text with login link at the bottom -->
        <div class="text-center mt-3">
            <p>Already have an account? <a href="login.php">Login</a></p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- JavaScript to calculate age -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const birthdateInput = document.getElementById('birthdate');
            const ageInput = document.getElementById('age');

            birthdateInput.addEventListener('change', function () {
                const birthDate = new Date(this.value);
                const today = new Date();
                let age = today.getFullYear() - birthDate.getFullYear();
                const monthDiff = today.getMonth() - birthDate.getMonth();
                if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
                ageInput.value = age;
            });
        });
    </script>
</body>
</html>
