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
	  // Intenta iniciar sesión
	  session_start();
	  // Verifica si hay datos de inicio de sesión
	  if (strlen(session_id()) < 1){
	    // Si no hay datos de inicio de sesión se vuelve al login
	    header ("Location: index.php");
	  }
	}

	$cant_unidad=$_POST["cant"];
	$id_aldea=$_SESSION["id_aldea"];
	$id_jugador=$_SESSION["id"];
	$tipo_unidad=$_POST["tipo_unidad"];
	$fecha = $_SESSION["fecha"];
	
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
    		$sql = "SELECT obtener_costo_unidad ('".$tipo_unidad."')";
			$result = pg_query($conexion,$sql);
			$costo = pg_fetch_row($result);
			$sql = "SELECT obtener_saldo ('".$id_jugador."')";
			$result = pg_query($conexion,$sql);
			$saldo = pg_fetch_row($result);
			echo "Saldo jugador = ".$saldo[0]."<br>";
			$costoTotal = $costo[0]*$cant_unidad;
			echo "Costo Compra = ".$costoTotal."<br>";
			if($costoTotal<$saldo[0])
			{
				$saldo_nuevo=$saldo[0] - $costoTotal;
				echo "Saldo nuevo = ".$saldo_nuevo."<br>";
				$sql = "SELECT modificar_saldo ('".$saldo_nuevo."','".$id_jugador."')";
			    $result = pg_query($conexion,$sql);
				$sql = "SELECT crear_unidad ('".$id_aldea."','".$tipo_unidad."','".$cant_unidad."')";
				$result = pg_query($conexion,$sql);
				//Debug
				if($result){
					echo "Unidad agregada<br>";
					echo "Compra Exitosa!<br>";

					//Para registrar transacción
					$sql = "SELECT registrar_transaccion ('".$fecha."','".$costoTotal."','Compra Unidad(es)','".$id_jugador."')";
					$result = pg_query($conexion,$sql);
					if($result) echo "Transacción registrada con fecha: ".$fecha."<br>";
				}
				else{
					echo "No se agregó unidad!<br>";
					echo "ERROR: No se realizó compra<br>";
					header ("Location: perfil.php");
				}
				//
				pg_close($conexion);
			}
			else
			{
				echo "Costo supera Saldo jugador<br>";
				echo "ERROR: No se realizó compra<br>";
				pg_close($conexion);
				header ("Location: perfil.php");
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