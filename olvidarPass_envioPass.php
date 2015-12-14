<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
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

<body>
    <div class="site-wrapper">
      <div class="site-wrapper-inner">
        <div class="cover-container">
			<div class="masthead clearfix">
				<div class="inner">
				  <h1 class="masthead-brand">Clash of Crews</h1>
				  <nav>
				    <ul class="nav masthead-nav">
				      <li><a href="index.php">Inicio</a></li>
				      <li><a href="contacto.html">Contacto</a></li>
				    </ul>
				  </nav>
				</div>
			</div>
			<div class="container-fluid">
<?php 
	//Recibir datos de olvidar.html
	$email = $_POST["email"];

	$conexion = pg_connect("host=localhost
							port=5432
							dbname=ClashOfCrews
							user=postgres
							password=tlozoot");

	if(!$conexion){
			echo "Conexion fallida :(<br>Revisa que los datos de conexión a la DB en registro.php sean correctos<br>";
	}
	else
	{
		//Verificar si existe el email en la base de datps
		$query = "SELECT verificar_email ('".$email."');";
		$result = pg_query($conexion,$query);
		$ver = pg_fetch_row($result);

		if ($ver[0]=='t') {

			//Obtener contraseña del usuario
			$query = "SELECT contraseña FROM jugador WHERE email='".$email."'";
			$result = pg_query($conexion,$query);
			$fila = pg_fetch_row($result);
			$pass = $fila[0];
			$mensaje = "Buenas,\nHa enviado una solicitud de envio de contraseña\nSu contraseña es: ".$pass."\nNos vemos!";

			//Funcion para enviar un email al usuario
			mail ( $email , "Recuperacion de contraseña", $mensaje ,"El equipo de Clash of Crews.", "" );
			header ("Location: olvidarPass_mailEnviado.html");
		}
		else  {
			echo ("<script>alert('El mail ingresado no existe');</script>");
			echo ("<a href='index.php'>Volver al inicio</a>");
		}
	}
?>
<!-- Fondo de la página -->
            <div class="mastfoot">
              <div class="inner">
                <p>Sitio desarrollado por:<br>Franco Valerio - Leandro Mondaca - Diego Mayorga</p>
              </div>
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