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

    $id_jugador = $_SESSION["id"];
    $exp = $_SESSION["exp"];
    $cantidad=1;
    $nombre_clan = $_POST["nombre_clan"];
 
    $conexion = pg_connect("host=localhost
                                port=5432
                                dbname=ClashOfCrews
                                user=postgres
                                password=tlozoot");
 
    if(!$conexion){
        echo "Conexion fallida :(<br>Revisa que los datos de conexión a la DB en crearClan.php sean correctos<br>";
    }
    else
    {

        $query = "SELECT verificar_clan('".$nombre_clan."')";
        $result = pg_query($conexion,$query);
        $ver = pg_fetch_row($result);
        if ($ver[0] == 'f') {
            $query = "SELECT crear_clan('".$nombre_clan."','1','".$exp."')";
            $consulta = pg_query($conexion,$query);

            //Obtener ID Aldea del jugador
            $query = "SELECT obtener_id_clan ('".$nombre_clan."')";
            $result = pg_query($conexion,$query);   
            $fila = pg_fetch_row($result);
            $id_clan_jugador = $fila[0];

            $query = "SELECT modificar_id_clan ('".$id_clan_jugador."','".$id_jugador."')";
            $result = pg_query($conexion,$query);           
            if ($result) {
                $_SESSION["id_clan"] = $id_clan_jugador;
            }
            pg_close($conexion);
            header ("Location: perfil.php");

        } 
        else {
            pg_close($conexion);
            echo "Ya existe un clan con el nombre ingresado<br>";
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
