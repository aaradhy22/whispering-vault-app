<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<!-- ADD THIS LINE: Essential for mobile responsiveness -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Unlock Your World</title>
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500&family=Caveat:wght@400;500&display=swap"
	rel="stylesheet">
<style>
/* --- Base Styles --- */
html, body {
	margin: 0;
	padding: 0;
	height: 100%;
	overflow: hidden;
	font-family: 'Poppins', sans-serif;
	background-color: #000;
	color: #988686;
}

body {
	background: radial-gradient(ellipse at center, #1b1b1b 0%, #000000 100%);
    /* CHANGE: Using Flexbox for more robust centering */
    display: flex;
    align-items: center;
    justify-content: center;
}

canvas {
	position: fixed;
	top: 0;
	left: 0;
	z-index: 1;
}

.content {
	z-index: 2;
	/* REMOVED: Absolute positioning no longer needed */
	text-align: center;
	padding: 20px; /* Add padding for small screens */
	animation: fadeIn 2s ease-in-out;
    width: 90%;
    max-width: 500px;
}

@keyframes fadeIn {
    from { opacity:0; transform: translateY(15px); }
    to { opacity: 1; transform: translateY(0); }
}

h1 {
	font-size: 2.8em;
	margin-bottom: 10px;
	text-shadow: 0 0 15px rgba(152, 134, 134, 0.3);
}

p {
	font-size: 1.2em;
	margin-top: 10px;
	white-space: normal;
}

/* --- Form Styles --- */
.form-container {
    margin-top: 40px;
}

.secret-input {
    background: transparent;
    border: 1px solid rgba(152, 134, 134, 0.4);
    border-radius: 10px;
    padding: 15px 20px;
    color: #e0dada;
    font-family: 'Poppins', sans-serif;
    font-size: 1.8em;
    letter-spacing: 12px;
    text-align: center;
    width: 250px;
    box-shadow: 0 0 10px rgba(152, 134, 134, 0.2);
    transition: all 0.3s ease;
    -moz-appearance: textfield;
}

.secret-input::-webkit-outer-spin-button,
.secret-input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

.secret-input::placeholder {
    color: rgba(152, 134, 134, 0.3);
    letter-spacing: 4px;
    font-size: 0.8em;
}

.secret-input:focus {
    outline: none;
    border-color: #988686;
    box-shadow: 0 0 25px rgba(152, 134, 134, 0.6);
}

.submitBtn {
	margin-top: 30px;
	padding: 14px 30px;
	background-color: transparent;
	border: 1px solid #988686;
	color: #988686;
	font-size: 16px;
	border-radius: 10px;
	cursor: pointer;
	text-transform: uppercase;
	letter-spacing: 1.5px;
	box-shadow: 0 0 10px rgba(152, 134, 134, 0.2);
	transition: all 0.3s ease;
}

.submitBtn:hover {
	transform: translateY(-3px);
	background-color: #988686;
	color: #000;
	box-shadow: 0 0 25px rgba(152, 134, 134, 0.6);
}

.error-message {
    color: #c97b7b;
    font-size: 0.9em;
    margin-top: 15px;
    height: 20px;
    opacity: 0;
    transition: opacity 0.3s ease-in-out;
}

<% if (request.getAttribute("error") != null) { %>
.error-message {
    opacity: 1;
}
<% } %>

/**************************************************/
/* ---     MOBILE RESPONSIVE STYLES     ---       */
/**************************************************/
@media (max-width: 768px) {
	h1 {
		font-size: 2em;
	}
	p {
		font-size: 1em;
	}
    .secret-input {
        width: 85%; /* Make the input field take up more screen width */
        font-size: 1.6em; /* Slightly smaller font for mobile */
        letter-spacing: 8px; /* Reduce spacing to fit digits better */
        padding: 12px 10px;
    }
    .secret-input::placeholder {
        letter-spacing: 2px; /* Adjust placeholder spacing too */
    }
}
</style>
</head>
<body>

	<canvas id="background-canvas"></canvas>

	<div class="content">
		<h1>Whisper the Code</h1>
		<p>The path is familiar, the silence awaits. Enter the key that guards your world.</p>
		
		<form action="Login" method="post" class="form-container" id="loginForm" onsubmit="return validateForm()">
			<input 
                type="text" 
                name="secret_code"
                class="secret-input" 
                required 
                maxlength="6" 
                pattern="[0-9]{6}"
                inputmode="numeric"
                title="Please enter your 6 digit key."
                placeholder="0 0 0 0 0 0"
                id="secretCodeInput"
                autocomplete="off" <%-- Good to add for secret codes --%>
                value="<% String code = (String) request.getParameter("secret_code"); if(code != null) out.print(code); %>"
            />
            
            <div id="errorMessage" class="error-message">
                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                        out.print(error);
                    }
                %>
            </div>
            
			<button type="submit" class="submitBtn">Unlock the World</button>
		</form>
	</div>

	<!-- The exact same "Rising Embers" animation script -->
	<script>
        const canvas = document.getElementById('background-canvas');
        const ctx = canvas.getContext('2d');
        let particlesArray;
        function setCanvasSize() { canvas.width = window.innerWidth; canvas.height = window.innerHeight; }
        window.addEventListener('resize', () => { setCanvasSize(); init(); });
        class Particle {
            constructor() { this.x = Math.random() * canvas.width; this.y = canvas.height + Math.random() * 100; this.size = Math.random() * 2.5 + 1; this.speedY = Math.random() * 1 + 0.5; this.speedX = (Math.random() - 0.5) * 0.5; this.opacity = this.size / 3.5; this.color = `rgba(152, 134, 134, \${this.opacity})`; }
            update() { this.y -= this.speedY; this.x += this.speedX; if (this.y < -10) { this.y = canvas.height + 10; this.x = Math.random() * canvas.width; this.size = Math.random() * 2.5 + 1; this.speedY = Math.random() * 1 + 0.5; this.opacity = this.size / 3.5; this.color = `rgba(152, 134, 134, \${this.opacity})`; } }
            draw() { ctx.fillStyle = this.color; ctx.shadowBlur = 5; ctx.shadowColor = this.color; ctx.beginPath(); ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2); ctx.fill(); }
        }
        function init() { particlesArray = []; const numberOfParticles = (canvas.width * canvas.height) / 10000; for (let i = 0; i < numberOfParticles; i++) { particlesArray.push(new Particle()); } }
        function animate() { ctx.clearRect(0, 0, canvas.width, canvas.height); ctx.shadowBlur = 0; ctx.shadowColor = 'transparent'; for (let i = 0; i < particlesArray.length; i++) { particlesArray[i].update(); particlesArray[i].draw(); } requestAnimationFrame(animate); }
        setCanvasSize(); init(); animate();

        const form = document.getElementById('loginForm');
        const input = document.getElementById('secretCodeInput');
        const errorMessage = document.getElementById('errorMessage');

        function validateForm() {
            errorMessage.textContent = '';
            errorMessage.style.opacity = '0';
            if (!form.checkValidity()) {
                errorMessage.textContent = "The key must be exactly 6 digits.";
                errorMessage.style.opacity = '1';
                input.style.animation = 'shake 0.5s';
                setTimeout(() => input.style.animation = '', 500);
                return false;
            }
            return true;
        }
        const style = document.createElement('style');
        style.innerHTML = `@keyframes shake { 10%, 90% { transform: translateX(-1px); } 20%, 80% { transform: translateX(2px); } 30%, 50%, 70% { transform: translateX(-4px); } 40%, 60% { transform: translateX(4px); } }`;
        document.head.appendChild(style);
	</script>

</body>
</html>