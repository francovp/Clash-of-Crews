<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title> Clash of Crews - Perfil de <?php echo ($nombre." ".$apellido)?></title>
    <meta name="description" content="">
    <meta name="Franco Valerio, Diego Mayorga, Leandro Mondaca" content="">
    <link rel="icon" href="../../favicon.ico">
  
  <!-- Bootstrap Online -->
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
                  <h1 class="masthead-brand">Clash of Crews Administrator</h1>
                  <nav>
                    <ul class="nav masthead-nav">
                      <li class="active"><a href="perfil.php">Inicio</a></li>
                  	  <li><a href="index.php">
                  	  <strong>Cerrar Sesión</strong></a></li>
                    </ul>
                  </nav>
                </div>
            </div>
            <div class="container-fluid">
<?php 
	if (!isset($_SESSION)) {
			session_start();
	}

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
		if (!isset($_SESSION))
		{
			session_start();
		}

		$id = $_SESSION["id"];
		$nombre = trim($_POST["nombre"]);
		$apellido = trim($_POST["apellido"]);
		$sexo = trim($_POST["sexo"]);
		$email = trim($_POST["mail"]);
		$pass = trim($_POST["pass"]);

		$query = "SELECT modificar_jugador ('".$nombre."','".$apellido."','".$sexo."','".$email."','".$pass."','".$id."')";
		$result = pg_query($conexion,$query);			
		if ($result) {
			$_SESSION["nombre"] = $nombre;
			$_SESSION["apellido"] = $apellido;
			$_SESSION["sexo"] = $sexo;
			$_SESSION["email"] = $email;
			$_SESSION["pass"] = $pass;
		}

		header ("Location: perfil.php");
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