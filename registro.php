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

<?php 
	$nombre = trim($_POST["nombre"]);
	$apellido = trim($_POST["apellido"]);
	$id = trim($_POST["id"]);
	$sexo = trim($_POST["sexo"]);
	$email = trim($_POST["mail"]);
	//$pass_oculta = crypt(trim($_POST["pass"]),$1$);
	$pass_oculta = trim($_POST["pass"]);
	
	$conexion = pg_connect("host=localhost
							port=5432
							dbname=ClashOfCrews
							user=postgres
							password=12345");

	if(!$conexion){
			echo "Conexion fallida :(<br>Revisa que los datos de conexión a la DB en registro.php sean correctos<br>";
	}
	else
	{
		//Se verifica que el usuario no haya sido registrado antes.
		$query = "SELECT verificar_email ('".$email."');";
		$result = pg_query($conexion,$query);
		$ver = pg_fetch_row ($result);
		//Si no se encuentra...
		if ($ver[0] == 'f') {
			//...Se procede a registrar al jugador...
			$query = "SELECT crear_jugador ('".$id."','".$nombre."','".$apellido."','".$sexo."','".$email."','".$pass_oculta."');";
			$result = pg_query($conexion,$query);			
			if ($result) {

				//Se obtiene id de la aldea creada
				$query = "SELECT obtener_id_aldea ('".$id."')";
				$result = pg_query($conexion,$query);	
				$id_aldea_jugador = pg_fetch_row($result);
				$id_aldea = $id_aldea_jugador[0];

				//Se obtienen datos de la DB para mostrarlas en el perfil
				$sql = "SELECT * FROM jugador WHERE (id_jugador = '".$id."');";
				$result = pg_query($conexion,$sql);
				$tupla = pg_fetch_row($result);

				//Se cierra conexi{on a la DB
				pg_close($conexion);
			}

			if (!isset($_SESSSION)) {
					session_start();
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

			header ("Location: perfil.php");
		}
		else {
			header ("Location: indexErrorRegistro.php");
		}
	}
?>
	</body>
</html>