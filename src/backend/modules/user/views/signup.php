<div class="centered">
    <form method="POST" id="signupForm">
        <p>First name</p>
        <output-error></output-error>
        <input type="text" name="firstName" id="firstNameInput" required>
        <p>Last name</p>
        <output-error></output-error>
        <input type="text" name="lastName" id="lastNameInput" required>
        <p>Email</p>
        <output-error></output-error>
        <input type="text" name="email" id="emailInput" required>
        <p>Password</p>
        <output-error></output-error>
        <input type="password" name="password" id="passwordInput" required>
        <p>Retype Password</p>
        <output-error></output-error>
        <input type="password" id="retypePasswordInput" required>
        <p>Gender</p>
        <output-error></output-error>
        <div id="genderSelector">
            <div>
                <input type="radio" name="gender" value="male" required>
                <label for="male">Male</label>
            </div>
            <div>
                <input type="radio" name="gender" value="female" required>
                <label for="female">Female</label>
            </div>
            <div>
                <input type="radio" name="gender" value="other" required>
                <label for="other">Other</label>
            </div>
        </div>
        <p>Birthday</p>
        <output-error></output-error>
        <input name="birthday" type="date" id="dateInput" required>
        <button id="signupButton">Signup</button>
        <a href="login.php">Login</a>
    </form>
</div>