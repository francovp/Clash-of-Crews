<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

	<title> Clash of Crews</title>
    <meta name="description" content="">
    <meta name="Franco Valerio, Diego Mayorga, Leandro Mondaca" content="">
    <link rel="icon" href="../../favicon.ico">
	
	<!-- Bootstrap -->
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
    <!-- Custom styles-->
    <link href="css/cover.css" rel="stylesheet">
	<link href="css/style.css"  rel="stylesheet" type="text/css" /> 
</head>

<style>
</style>

<body>
    <div class="site-wrapper">

      <div class="site-wrapper-inner">

        <div class="cover-container">

			<div class="masthead clearfix">	
				<div class="inner">
				  <h1 class="masthead-brand">Clash of Crews</h1>
				  <nav>
				    <ul class="nav masthead-nav">
				      <li class="active"><a href="index.php">Inicio</a></li>
				      <li><a href="contacto.html">Contacto</a></li>
				    </ul>
				  </nav>
				</div>
			</div>
			<div class="container-fluid">
				<div class="row">
					<div class="col-sm-6">
						<div class="login">
							<header  class="tabla">
								<form class="form-signin" action="login.php" method="POST">
									<center>
										<strong><h1 class="form-signin-heading">Ingresa!</h2></strong><br>
								        <input type="text" id="ingresoId" name="id" class="form-control" placeholder="ID jugador" required autofocus><br>
								        <input type="password" id="ingresoPassword" name="pass" class="form-control" placeholder="Contraseña" required autofocus>
								        <a href="olvidar.html">¿Olvidaste tu contraseña?</a><br>
								        <div class="checkbox">
								          <label>
								            <input type="checkbox" value="recuerdame"> Recuerdame
								          </label>
								        </div>
								        <button class="btn btn-lg btn-default" type="submit">Ingresar</button><br><br>
								    </center>
								</form>
							</header>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="registro">
							<header  class="tabla">
								<form action="registro.php" method="POST">
									<center>
										<strong><h1 class="form-signin-heading">Registrate!</h1></strong><br>
										<input type="text" id="ingresoId" name="id" class="form-control" placeholder="ID de jugador" required autofocus><br>
										<input type="text" id="ingresoNombre" name="nombre" class="form-control" placeholder="Nombre" required autofocus><br>
										<input type="text" id="ingresoApellido" name="apellido" class="form-control" placeholder="Apellido" required autofocus><br>
										<select id="ingresoSexo" class="form-control" name="sexo">
											<option>Genero...</option>
											<option>Masculino</option>
											<option>Femenino</option>
										</select><br>
										<input type="email" id="ingresoEmail" name="mail" class="form-control" placeholder="Email" required autofocus><br>
									    <input type="password" id="ingresoPassword" name="pass" class="form-control" placeholder="Contraseña" required autofocus>
									    <h3><span class="label label-danger">Error! Email ya registrado</span></h3>

										<button class="btn btn-lg btn-default" type="submit">Registrarse</button><br><br>
									</center>
								</form>
							</header>
						</div>
					</div>
				</div>

				<?php
				if (isset($_SESSION))
					 session_destroy();
				?>
				<br>
				<div class="mastfoot">
					<div class="inner">
						<p>Sitio desarrollado por:<a href="https://twitter.com/FrancoVP"> Franco Valerio</a> - Leandro Mondaca - Diego Mayorga</p>
					</div>
				</div>
			</div>
		</div>
    </div>

	<!-- Bootstrap core JavaScript
    ================================================== -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
</body>
</html>
