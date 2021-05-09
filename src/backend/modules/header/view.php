
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>AUTOCARS - <?= $this->get_title() ?> </title>
	<link rel="stylesheet" href="/public/css/main.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="/public/js/lang.js" async defer></script>
	<script src="/public/js/cars.js" async defer></script>
</head>
<body>
<div id="header"><div id="header-content">
	<div class="logo">Autocars</div>
		<div id="header-pages">
			<a href="/cars/" class="header-box">Cars</a>
			<a href="/contact/" class="header-box">Contact</a>
			<a href="/info/" class="header-box">Info</a>
		</div>
		<div id="header-access">
			<div id="language-menu-hidden"></div>
			<div class="header-box" id="language">Language</div>
			<a class="header-box" href="/user/login/">Login</a>
			<a class="header-box" href="/user/signup/">Signup</a>
		</div>

	</div>
</div>
<div id="main">

