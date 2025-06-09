<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<!-- ADD THIS LINE: Essential for mobile responsiveness -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>The Lock is Sealed</title>
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
    /* CHANGE: Using Flexbox for robust centering */
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
    max-width: 550px;
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

.actionBtn {
	margin-top: 40px;
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
    text-decoration: none; /* Good practice for link-like buttons */
}

.actionBtn:hover {
	transform: translateY(-3px);
	background-color: #988686;
	color: #000;
	box-shadow: 0 0 25px rgba(152, 134, 134, 0.6);
}

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
}
</style>
</head>
<body>

	<canvas id="background-canvas"></canvas>

	<div class="content">
		<h1>The Lock is Sealed</h1>
		<p>Your secret world is now protected. The key is yours alone to keep. You may now begin to fill the silence.</p>
        
        <%-- Using an <a> tag is slightly better for navigation than a <button> with JS --%>
		<a href="login.jsp" class="actionBtn">Enter Your World</a>
	</div>

	<!-- The same "Rising Embers" animation script -->
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
	</script>

</body>
</html>