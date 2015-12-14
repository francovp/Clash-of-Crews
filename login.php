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
    <!-- <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css"> -->
	<link rel="stylesheet" href="css/bootstrap.min.css">
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
				      <li class="active"><a href="index.php">Inicio</a></li>
				      <li><a href="contacto.html">Contacto</a></li>>
				    </ul>
				  </nav>
				</div>
			</div>
			<div class="container-fluid">
			<?php 
				$id = trim($_POST["id"]);
				//$pass_oculta = crypt(trim($_POST["pass"]),$1$);
				$pass_oculta = trim($_POST["pass"]);

				$debug = $_POST["debug"];

				$conexion = pg_connect("host=localhost
										port=5432
										dbname=ClashOfCrews
										user=postgres
										password=12345");

				if(!$conexion){
						echo "Conexion fallida : ".pg_last_error()."
						<br>Revisa que los datos de conexión a la DB en login.php sean correctos<br>
						";
				}
				else
				{									
					$query = "SELECT verificar_usuario ('".$id."','".$pass_oculta."');";
					$result = pg_query($conexion,$query);
					$ver = pg_fetch_row ($result);

					if ($ver[0] == 't') {

						//Debug
							echo "<br>El usuario existe y su contraseña está correcta<br>";
							echo "<br>ID usuario: ".$id."<br>";
						//

						//Obtener datos del jugador
						$query = "SELECT * FROM jugador WHERE (id_jugador = '".$id."');";
						$result = pg_query($conexion,$query);
						$tupla = pg_fetch_row($result);

						//Obtener ID Aldea del jugador
						$query = "SELECT obtener_id_aldea ('".$id."')";
						$result = pg_query($conexion,$query);	
						$fila = pg_fetch_row($result);
						$id_aldea = $fila[0];

						pg_close($conexion);

						if (!isset($_SESSSION)) {
								session_start();
								session_regenerate_id(true);
						}

							$_SESSION["id"] = $tupla[0];
							$_SESSION["nombre"] = $tupla[1];
							$_SESSION["apellido"] = $tupla[2];
							$_SESSION["email"] = $tupla[3];
							$_SESSION["pass"] = $tupla[4];
							$_SESSION["saldo"] =$tupla[5];
							$_SESSION["exp"] =$tupla[6];
							$_SESSION["sexo"] =$tupla[7];
							$_SESSION["id_clan"] =$tupla[8];
							$_SESSION["id_aldea"] =$id_aldea;

						if(!$debug)
						{
							header ("Location: perfil.php");
						}
						//Debug
							else{

							 	$id = $_SESSION["id"];
							 	echo $id." Se ha logeado";
							}
						//
					}
					else {
						if(!$debug){
							header ("Location: indexErrorLogin.php");
						}
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
    <!-- <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script> -->
	<script src="js/bootstrap.min.js"></script>

  </body>
</html>