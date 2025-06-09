<%-- JSTL taglib has been REMOVED as we are not using it --%>
<%@page import="com.secretletters.models.Letter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList"%>

<%
/*******************************************************************/
/* --- SECURITY CHECK: The Bouncer at the Door ---                 */
/*******************************************************************/
HttpSession sessionRef = request.getSession(false);
String userCode = null;

if (sessionRef != null) {
	userCode = (String) sessionRef.getAttribute("user_code");
}

if (userCode == null) {
	response.sendRedirect("login.jsp");
	return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Whispering Vault</title>
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500&family=Caveat:wght@400;700&display=swap"
	rel="stylesheet">
<style>
/* --- BASE STYLES --- */
html, body {
	margin: 0;
	padding: 0;
	font-family: 'Poppins', sans-serif;
	background-color: #000;
	color: #988686;
}

body {
	background: radial-gradient(ellipse at center, #1b1b1b 0%, #000000 100%);
	overflow: hidden; /* DESKTOP: Prevent body scroll */
}

canvas {
	position: fixed;
	top: 0;
	left: 0;
	z-index: 1;
	pointer-events: none;
}

/* --- MAIN LAYOUT & HEADER --- */
.sanctum-container {
	position: relative;
	z-index: 2;
	height: 100vh; /* DESKTOP: Full height */
	display: flex;
	flex-direction: column;
	max-width: 1200px;
	margin: 0 auto;
	padding: 0 40px;
	box-sizing: border-box;
}

.dashboard-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 30px 0;
	flex-shrink: 0;
	animation: fadeInDown 1s ease-out;
}

h1 {
	font-family: 'Caveat', cursive;
	font-size: 3.5em;
	margin: 0;
	text-shadow: 0 0 20px rgba(152, 134, 134, 0.4);
}

.logout-btn {
	padding: 10px 20px;
	background-color: transparent;
	border: 1px solid #988686;
	color: #988686;
	font-size: 14px;
	border-radius: 10px;
	cursor: pointer;
	text-transform: uppercase;
	letter-spacing: 1.5px;
	transition: all 0.3s ease;
	text-decoration: none;
}

.logout-btn:hover {
	background-color: #988686;
	color: #000;
	box-shadow: 0 0 15px rgba(152, 134, 134, 0.4);
}

/* --- TWO-PANE LAYOUT (DESKTOP) --- */
.main-content {
	display: flex;
	flex-grow: 1;
	gap: 40px;
	padding-bottom: 40px;
	min-height: 0; /* Critical fix for flexbox scrolling */
}

.left-pane, .right-pane {
	padding: 30px;
	background: rgba(15, 15, 15, 0.4);
	backdrop-filter: blur(8px);
	border: 1px solid rgba(152, 134, 134, 0.15);
	border-radius: 15px;
}

.pane-title {
	font-family: 'Caveat', cursive;
	font-size: 2em;
	margin-top: 0;
	margin-bottom: 25px;
	text-align: center;
	font-weight: 700;
}

/* --- LEFT PANE (THE SCRIPTORIUM) --- */
.left-pane {
	flex: 1;
	display: flex;
	flex-direction: column;
	animation: fadeInLeft 1.2s ease-out;
}

.letter-form {
	display: flex;
	flex-direction: column;
	height: 100%;
}

.letter-input {
	flex-grow: 1;
	background: transparent;
	border: none;
	color: #e0dada;
	font-family: 'Caveat', cursive;
	font-size: 1.8em;
	line-height: 1.6;
	resize: none;
	padding: 10px;
}

.letter-input:focus {
	outline: none;
}

.submitBtn {
	margin-top: 20px;
	padding: 14px 30px;
	background-color: transparent;
	border: 1px solid #988686;
	color: #988686;
	font-size: 16px;
	border-radius: 10px;
	cursor: pointer;
	text-transform: uppercase;
	letter-spacing: 1.5px;
	transition: all 0.3s ease;
}

.submitBtn:hover {
	transform: translateY(-3px);
	background-color: #988686;
	color: #000;
	box-shadow: 0 0 25px rgba(152, 134, 134, 0.6);
}

/* --- RIGHT PANE (THE ARCHIVE) --- */
.right-pane {
	flex: 1;
	overflow-y: auto; /* DESKTOP: Internal scroll */
	animation: fadeInRight 1.2s ease-out;
}

.right-pane::-webkit-scrollbar { width: 8px; }
.right-pane::-webkit-scrollbar-track { background: transparent; }
.right-pane::-webkit-scrollbar-thumb {
	background-color: rgba(152, 134, 134, 0.3);
	border-radius: 10px;
	border: 2px solid transparent;
	background-clip: content-box;
}
.right-pane::-webkit-scrollbar-thumb:hover { background-color: rgba(152, 134, 134, 0.5); }

/* --- LETTER ENTRY STYLING --- */
.letter-entry {
	position: relative;
	background: rgba(245, 245, 220, 0.05);
	border: 1px solid rgba(152, 134, 134, 0.3);
	border-radius: 8px;
	padding: 25px;
	margin-bottom: 25px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
	transition: transform 0.3s ease, box-shadow 0.3s ease;
	opacity: 0;
	animation: entryFadeIn 0.8s forwards ease-out;
}

.letter-entry:hover {
	transform: translateY(-5px) scale(1.02);
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.5);
}

.letter-content-display {
	white-space: pre-wrap;
	word-wrap: break-word;
	padding-bottom: 15px;
	font-family: 'Caveat', cursive;
	font-size: 1.6em;
	line-height: 1.7;
	color: #e0dada;
}

.letter-meta {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 15px;
	border-top: 1px solid rgba(152, 134, 134, 0.2);
	padding-top: 15px;
}

.letter-entry .timestamp {
	font-size: 0.9em;
	color: #888;
	font-family: 'Poppins', sans-serif;
}

.letter-actions { display: flex; gap: 10px; }
.action-btn {
	background: rgba(255, 255, 255, 0.1); border: none; color: #ccc;
	cursor: pointer; padding: 5px 10px; border-radius: 5px; font-size: 12px;
	text-decoration: none; transition: all 0.3s ease;
}
.action-btn.delete:hover { background-color: #c97b7b; color: #fff; }
.action-btn.edit:hover { background-color: #988686; color: #000; }

.letter-entry textarea.edit-mode {
	width: 100%; box-sizing: border-box; background: transparent; color: #fff;
	border: none; border-bottom: 1px solid #988686; border-radius: 0;
	font-family: 'Caveat', cursive; font-size: 1.6em; line-height: 1.7;
	resize: none; overflow: hidden;
}

/* --- ANIMATIONS --- */
@keyframes fadeInDown {
	from { opacity: 0; transform: translateY(-30px); }
	to { opacity: 1; transform: translateY(0); }
}
@keyframes fadeInLeft {
	from { opacity: 0; transform: translateX(-50px); }
	to { opacity: 1; transform: translateX(0); }
}
@keyframes fadeInRight {
	from { opacity: 0; transform: translateX(50px); }
	to { opacity: 1; transform: translateX(0); }
}
@keyframes entryFadeIn {
	from { opacity: 0; transform: translateY(20px); }
	to { opacity: 1; transform: translateY(0); }
}

/**************************************************/
/* ---     MOBILE RESPONSIVE STYLES     ---       */
/**************************************************/
@media (max-width: 800px) {
	body {
		overflow: auto; /* MOBILE: Allow the whole page to scroll */
	}

	.sanctum-container {
		height: auto; /* MOBILE: Height grows with content */
		min-height: 100vh;
		padding: 0 20px;
	}

	.dashboard-header h1 {
		font-size: 2.5em;
	}

	.main-content {
		flex-direction: column; /* MOBILE: Stack panes vertically */
		min-height: initial; /* Unset the desktop flex fix */
		gap: 25px;
	}

	.left-pane {
		min-height: 50vh; /* Give the writing area a good default height */
	}

	.right-pane {
		overflow-y: visible; /* MOBILE: Let the body handle scrolling */
	}
}
</style>
</head>
<body>
	<canvas id="background-canvas"></canvas>
	
	<div class="sanctum-container">
		<div class="dashboard-header">
			<h1>Whispering Vault</h1>
			<a href="Logout" class="logout-btn">Leave World</a>
		</div>

		<div class="main-content">
			<!-- LEFT PANE: SCRIPTORIUM -->
			<div class="left-pane">
				<h2 class="pane-title">The Unwritten Page</h2>
				<div class="letter-form">
					<form action="Letter" method="post" style="display: flex; flex-direction: column; height: 100%;">
						<textarea name="letter_content" class="letter-input"
							placeholder="Pen your silent truth here..."></textarea>
						<button type="submit" class="submitBtn">Seal the Whisper</button>
					</form>
				</div>
			</div>

			<!-- RIGHT PANE: ARCHIVE -->
			<div class="right-pane">
				<h2 class="pane-title">Echoes from the Vault</h2>

				<%-- The Java logic here remains identical --%>
				<%
				List<Letter> letterList = (List<Letter>) request.getAttribute("letterList");
				if (letterList != null && !letterList.isEmpty()) {
					int i = 0;
					for (Letter letter : letterList) {
				%>
				<div class="letter-entry" id="letter-<%=letter.getId()%>" style="animation-delay: <%= i * 100 %>ms;">
					<div class="letter-content-display"><%=letter.getContent()%></div>
					<form action="editLetter" method="post" class="edit-form" style="display: none;">
						<input type="hidden" name="id" value="<%=letter.getId()%>">
						<textarea name="content" class="edit-mode"><%=letter.getContent()%></textarea>
						<button type="submit" class="submitBtn"
							style="font-size: 14px; padding: 8px 16px; margin-top: 10px;">Save
							Changes</button>
					</form>
					<div class="letter-meta">
						<span class="timestamp"><%=letter.getFormattedTimestamp()%></span>
						<div class="letter-actions">
							<button type="button" class="action-btn edit"
								onclick="toggleEdit(<%=letter.getId()%>)">Edit</button>
							<a href="editLetter?id=<%=letter.getId()%>"
								class="action-btn delete"
								onclick="return confirm('Are you sure you want this whisper to fade away?');">X</a>
						</div>
					</div>
				</div>
				<%
					i++;
					} 
				} else { 
				%>
				<div class="letter-entry" style="animation-delay: 0ms;">
					<div class="letter-content-display">Your sanctum is quiet. The first whisper awaits.</div>
				</div>
				<%
				}
				%>
			</div>
		</div>
	</div>

	<%-- The script block remains identical --%>
	<script>
    const canvas = document.getElementById('background-canvas');
    const ctx = canvas.getContext('2d');
    let particlesArray;
    function setCanvasSize() { canvas.width = window.innerWidth; canvas.height = window.innerHeight; }
    window.addEventListener('resize', () => { setCanvasSize(); init(); });
    class Particle { constructor() { this.x = Math.random() * canvas.width; this.y = canvas.height + Math.random() * 100; this.size = Math.random() * 2.5 + 1; this.speedY = Math.random() * 1 + 0.5; this.speedX = (Math.random() - 0.5) * 0.5; this.opacity = this.size / 3.5; this.color = `rgba(152, 134, 134, \${this.opacity})`; } update() { this.y -= this.speedY; this.x += this.speedX; if (this.y < -10) { this.y = canvas.height + 10; this.x = Math.random() * canvas.width; this.size = Math.random() * 2.5 + 1; this.speedY = Math.random() * 1 + 0.5; this.opacity = this.size / 3.5; this.color = `rgba(152, 134, 134, \${this.opacity})`; } } draw() { ctx.fillStyle = this.color; ctx.shadowBlur = 5; ctx.shadowColor = this.color; ctx.beginPath(); ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2); ctx.fill(); } }
    function init() { particlesArray = []; const numberOfParticles = (canvas.width * canvas.height) / 10000; for (let i = 0; i < numberOfParticles; i++) { particlesArray.push(new Particle()); } }
    function animate() { ctx.clearRect(0, 0, canvas.width, canvas.height); ctx.shadowBlur = 0; ctx.shadowColor = 'transparent'; for (let i = 0; i < particlesArray.length; i++) { particlesArray[i].update(); particlesArray[i].draw(); } requestAnimationFrame(animate); }
    setCanvasSize(); init(); animate();
	function autoResizeTextarea(textarea) { textarea.style.height = 'auto'; textarea.style.height = textarea.scrollHeight + 'px'; }
    function toggleEdit(letterId) {
        const letterEntry = document.getElementById('letter-' + letterId);
        const displayDiv = letterEntry.querySelector('.letter-content-display');
        const editForm = letterEntry.querySelector('.edit-form');
        const isHidden = editForm.style.display === 'none';
        if (isHidden) {
            displayDiv.style.display = 'none';
            editForm.style.display = 'block';
            const textarea = editForm.querySelector('textarea.edit-mode');
            autoResizeTextarea(textarea);
            textarea.focus();
        } else {
            displayDiv.style.display = 'block';
            editForm.style.display = 'none';
        }
    }
    document.addEventListener('DOMContentLoaded', () => {
        const allTextareas = document.querySelectorAll('textarea');
        allTextareas.forEach(textarea => {
            textarea.addEventListener('input', () => autoResizeTextarea(textarea));
			if (textarea.classList.contains('edit-mode')) { autoResizeTextarea(textarea); }
        });
    });
	</script>
</body>
</html>