<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title> Clash of Crews - Perfil de <?php echo ($nombre." ".$apellido)?></title>
    <meta name="description" content="">
    <meta name="Franco Valerio, Diego Mayorga, Leandro Mondaca" content="">
    <link rel="icon" href="../../favicon.ico">

  <!-- AngularJS y Jquery -->
    <script src= "http://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>
    <script src="jQueryAssets/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="jQueryAssets/jquery-ui-1.9.2.button.custom.min.js" type="text/javascript"></script>
  
  <!-- Bootstrap Online -->
    <!-- <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css"> -->
	<link rel="stylesheet" href="css/bootstrap.min.css"> 

  <!-- Custom styles-->
    <link href="css/cover.css" rel="stylesheet">
    <link href="css/style.css"  rel="stylesheet" type="text/css" />
  <!-- Styles Jquery -->
    <link href="jQueryAssets/jquery.ui.core.min.css" rel="stylesheet" type="text/css">
    <link href="jQueryAssets/jquery.ui.theme.min.css" rel="stylesheet" type="text/css">
    <link href="jQueryAssets/jquery.ui.button.min.css" rel="stylesheet" type="text/css">
  </head>

<!-- ----------------------------------------------------------------------------------------- -->
  <?php
    // Verifica si es que no se ha iniciado una sesión
    if (!isset($_SESSION)) {
      // Intenta iniciar sesión
      session_start();
      // Verifica si hay datos de inicio de sesión
      if (strlen(session_id()) < 1){
        // Si no hay datos de inicio de sesión se vuelve al login
        header ("Location: index.php");
      }
      else{
        // Si está activado "Recuerdame", Activarlo (No funcionando)
        //$session = $_POST["recuerdame"];
      }
    }

    // Guarda datos de sesión en variables para ser ocupados después
    $id = $_SESSION["id"];
    $nombre = $_SESSION["nombre"];
    $apellido =  $_SESSION["apellido"];
    $sexo = $_SESSION["sexo"];
    $email = $_SESSION["email"];
    $pass = $_SESSION["pass"];
    $saldo = $_SESSION["saldo"];
    $exp = $_SESSION["exp"];
    $id_clan = $_SESSION["id_clan"];
    $id_aldea = $_SESSION["id_aldea"];

    // Codigo para obtener fecha actual
      date_default_timezone_set('America/Santiago');
      $fecha = date('j-n-o h:i:s');
      $_SESSION["fecha"] = $fecha;

    //Abrir conexión con base de datos
    $conexion = pg_connect("host=localhost
                            port=5432
                            dbname=ClashOfCrews
                            user=postgres
                            password=12345");

    if(!$conexion){
      echo "Conexion fallida :(<br>Revisa que los datos de conexión a la DB en perfil.php sean correctos<br>";
    }
    else{

//Para calcular Experiencia Jugador -------------------------------------------------
      $sql = "SELECT obtener_id_aldea('".$id."')";
      $result = pg_query($conexion,$sql);
      $fila = pg_fetch_row($result);
      $id_aldea = $fila[0];

      $query = "SELECT exp FROM jugador WHERE (id_jugador = '".$id."');";
      $result = pg_query($conexion,$query);
      $fila = pg_fetch_row($result);
      $expActual = $fila[0];

      //Obtener Datos de Edificio
      $query = "SELECT * FROM edificio_jugador WHERE (id_aldea = '".$id_aldea."');";
      $result = pg_query($conexion,$query);

      $expTotal = 0;
      while($fila=pg_fetch_row($result)){
          $query = "SELECT obtener_expbase_edificios ('".$fila[2]."')";
          $res = pg_query($conexion,$query); 
          $row = pg_fetch_row($res);
          $exp = $row[0];
          $expEdificio = $exp * $fila[1];
          $expTotal = $expEdificio + $expTotal;
      } 

      if($expActual != $expTotal){
        //Actualizará valor exp en tabla jugador
        $query = "SELECT modificar_exp_jugador ('".$expTotal."','".$id."')";
        pg_query($conexion,$query); 
      }        
    }

  ?>

<!-- ----------------------------------------------------------------------------------------- -->
  <body>
    <div class="site-wrapper">
      <div class="site-wrapper-inner">
        <div class="cover-container">
          <div class="masthead clearfix">
            <div class="inner">
              <h3 class="masthead-brand"><strong>Clash of Crews Administrator</strong></h3>
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
            
            <h1> 
            <strong><center> Bienvenido <?php echo $nombre;?>!</center></strong><br>

            <!-- Botón para activar modal Datos Personales -->
            <button type="button" class="btn btn-lg btn-default" data-toggle="modal" data-target="#modalDatosPersonales">
            <strong>Ver datos personales</strong></button>

            <!-- Botón para mostrar la Aldea del jugador -->
            <button type="button" class="btn btn-lg btn-primary" data-toggle="modal" data-target="#modalVerAldea">
            <strong>Ve tu aldea</strong></button>

            <!-- Botón para mostrar información de clan -->
            <button type="button" class="btn btn-lg btn-info" data-toggle="modal" data-target="#modalClan">
            <strong>Ve tu clan</strong></button><br><br>

            <!-- Botón para activar modal Agregar Saldo -->
            <button type="button" class="btn btn-lg btn-warning" data-toggle="modal" data-target="#modalAgregarSaldo">
            <strong>Agregar Saldo</strong></button>

            <!-- Botón para activar modal Ataque -->
            <button type="button" class="btn btn-lg btn-danger" data-toggle="modal" data-target="#modalAtaque">
            <strong>Realizar Ataque</strong></button><br><br>

            <!-- Botón para activar modal de Bandeja de Entrada de mensaje -->
            <button type="button" class="btn btn-lg btn-success" data-toggle="modal" data-target="#modalMensajes">
            <strong>Bandeja de Mensajes</strong></button>
            </h1>

<!-- --------------------------------------------------------------------------------------------------------------------------------------- -->            
<!-- Modal Datos personales-->

            <div class="modal fade" id="modalDatosPersonales" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
    
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Mis Datos personales</h4>
                  </div>
    
                  <div class="modal-body">
                      <?php
                        echo "<strong>ID del jugador:</strong> ".$id."<br>
                              <strong><br>Nombre Completo:</strong> ".$nombre." ".$apellido."<br>
                              <strong><br>Genero:</strong> ".$sexo."<br>
                              <strong><br>Email:</strong> ".$email."<br>
                              <strong><br>Saldo Total:</strong> ".$saldo."<br>
                              <strong><br>Experiencia Total:</strong> ".$expTotal."<br>";
                        if($id_clan){
                          //Obtener nombre del clan del jugador
                          $query = "SELECT * FROM clan WHERE (id_clan = '".$id_clan."')";
                          $result2 = pg_query($conexion,$query);   
                          $fila = pg_fetch_row($result2);
                          $nombre_clan = $fila[3];

                          echo "<strong><br>Miembro del clan:</strong> ".$nombre_clan."<br>";
                        }
                      ?>
                  </div>
                  <div class="modal-footer">
                    <!-- Button trigger modal Modificar Datos Personales -->
                    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#modalModificarDatos">
                      Modificar Datos
                    </button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                  </div>
                </div>
              </div>
            </div>

<!-- --------------------------------------------------------------------------------------------------------------------------------------- -->       
<!-- Modal Modificar Datos Personales-->
            <div class="modal fade" id="modalModificarDatos" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content"> <!-- Aquí van la class del script de autoformulario -->
                  <div class="modal-header">
                    <h4 class="modal-title" id="myModalLabel">Modificar datos personales</h4>
                  </div>
                  <form action="modificarJugador.php" method="POST" ng-app="myApp" ng-controller="formCtrl" novalidate>
                    <div class="modal-body">
    
                        <!-- Script para autoformulario con valores predeterminados del usuario logeado -->
                      <script>
                          var app = angular.module('myApp', []);
                          app.controller('formCtrl', function($scope) {
                            $scope.nombre = <?php echo "'".$nombre."'"?>;
                            $scope.apellido = <?php echo "'".$apellido."'"?>;
                            $scope.email = <?php echo "'".$email."'"?>;
                            $scope.pass = <?php echo "'".$pass."'"?>;
                          });
                        </script>
    
                        <div class="form-group">
                          <label for="ingresoNombre">Nombre: </label>
                          <input type="text" id="ingresoNombre" name="nombre" class="form-control" placeholder="Nombre" ng-model="nombre" required autofocus>
                        </div>
                        <div class="form-group">
                          <label for="ingresoApellido">Apellido: </label>
                          <input type="text" id="ingresoApellido" name="apellido" class="form-control" placeholder="Apellido" ng-model="apellido" required autofocus>
                        </div>
                        <?php
                          if($sexo == 'Masculino'){
                            echo "<div class=\"form-group\">
                              <label for=\"ingresoSexo\">Genero: </label>
                              <select id=\"ingresoSexo\" class=\"form-control\" name=\"sexo\">
                                <option>Masculino</option>
                                <option>Femenino</option>
                              </select>
                            </div>
                            ";
                          }else{
                            echo "<div class=\"form-group\">
                              <label for=\"ingresoSexo\">Genero: </label>
                              <select id=\"ingresoSexo\" class=\"form-control\" name=\"sexo\">
                                <option>Femenino</option>
                                <option>Masculino</option>
                              </select>
                            </div>
                            ";
                          }
                        ?>
                        <div class="form-group">
                          <label for="ingresoEmail">Email: </label>
                          <input type="email" id="ingresoEmail" name="mail" class="form-control" placeholder="Email" ng-model="email" required autofocus>
                        </div>
                        <div class="form-group">
                          <label for="ingreso">Contraseña: </label>
                          <input type="password" id="ingresoPassword" name="pass" class="form-control" placeholder="Contraseña" ng-model="pass" required autofocus>
                        </div>
                        
                    </div>
                    <div class="modal-footer">
                      <button type="submit" class="btn btn-primary">
                        Actualizar Datos
                      </button>
                      <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                    </div>
                  </form>
                </div>
              </div>
            </div>


<!-- --------------------------------------------------------------------------------------------------------------------------------------- -->  
<!-- Modal Mostrar Aldea Jugador-->

            <div class="modal fade" id="modalVerAldea" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content"> <!-- Aquí van la class del script de autoformulario -->
                  <div class="modal-header">
                    <h4 class="modal-title" id="myModalLabel">Tu Aldea</h4>
                  </div>
                    <div class="modal-body">
                      <?php
                        if($conexion)
                        {
                          //Mostrar tabla de unidades
                          $query = "SELECT * FROM detalle_unidades WHERE (id_aldea = '".$id_aldea."');";
                          $result = pg_query($conexion,$query);
                          $num_filas = pg_num_rows($result);
                          echo "<strong>Unidades </strong><br><br>";

                          echo "
                          <table class=\"table\" cellspacing=1 border=1>
                            <thead>
                              <tr>
                              <th>Nombre Unidad</th>
                              <th>Cantidad</th>
                              </tr>
                            </thead>
                            <tbody>
                          ";
                          
                          while($col= pg_fetch_row($result)){
                                echo "<tr>";
                                // Se obtiene la ID de la unidad de la fila actual
                                $id_unidad = $col[1];
                                $query = "SELECT obtener_nombre_unidad ('".$id_unidad."')";
                                $res = pg_query($conexion,$query); 
                                $row = pg_fetch_row($res);
                                $nombre_unidad = $row[0];
                                
                                echo "<td>".$nombre_unidad."</td>";
                                echo "<td>".$col[2]."</td>";
                                echo "</tr>";
                          }
                          echo "</tbody>
                          </table>";

                          //Mostrar Tabla de Edificios
                          $query = "SELECT * FROM edificio_jugador WHERE (id_aldea = '".$id_aldea."');";
                          $result = pg_query($conexion,$query);
                          $num_filas = pg_num_rows($result);
                          echo "<strong>Edificios </strong><br><br>";

                          echo "
                          <table class=\"table\" cellspacing=1 border=1>
                            <thead>
                              <tr>
                              <th>Nombre Edificio</th>
                              <th>Nivel</th>
                              </tr>
                            </thead>
                            <tbody>
                          ";

                          while($col= pg_fetch_row($result)){
                                echo "<tr>";
                                // Se obtiene la ID de la unidad de la fila actual
                                $id_edificio = $col[2];
                                $query = "SELECT obtener_nombre_edificio ('".$id_edificio."')";
                                $res = pg_query($conexion,$query); 
                                $row = pg_fetch_row($res);
                                $nombre_edificio = $row[0];
                                
                                echo "<td>".$nombre_edificio."</td>";
                                echo "<td>".$col[1]."</td>";
                                echo "</tr>";
                          }
                          echo "</tbody>
                          </table>";
                        }
                        else{
                           echo "No se puede mostrar datos porque no hay conexión con la base de datos<br>";
                        }
                      ?>

                      <div class="modal-footer">
                        <!-- Button trigger modal Comprar Edificios -->
                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#modalComprarEdificios">
                          Comprar Edificios
                        </button>
                        <!-- Button trigger modal Comprar Unidades -->
                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#modalNivelEdificio">
                          Subir nivel edificio
                        </button>
                        <!-- Button trigger modal Comprar Unidades -->
                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#modalComprarUnidades">
                          Comprar Unidades
                        </button><br><br>
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                      </div>

                      <script>
                      $(document).ready(function(){
                          $(".nav-tabs a").click(function(){
                              $(this).tab('show');
                          });
                          $('.nav-tabs a').on('shown.bs.tab', function(event){
                              var x = $(event.target).text();         // active tab
                              var y = $(event.relatedTarget).text();  // previous tab
                              $(".act span").text(x);
                              $(".prev span").text(y);
                          });
                      });
                      </script>

                    </div>
                </div>
              </div>
            </div>   


<!-- --------------------------------------------------------------------------------------------------------------------------------------- -->   
<!-- Modal Subir nivel de Edificios-->

            <div class="modal fade" id="modalNivelEdificio" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
    
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Subir nivel de Edificio</h4>
                  </div>
                  <form action="subirNivelEdificio.php" method="POST">
                    <div class="modal-body">
                    <?php
                        if($conexion)
                        {
                            //Obtener datos del clan del jugador
                            $query = "SELECT * FROM edificio_jugador WHERE (id_aldea = '".$id_aldea."')";
                            $result = pg_query($conexion,$query);  

                              //Se crea un ciclo para crear listas hasta una cantidad igual a la de edificios
                              while($fila = pg_fetch_row($result)){ 
                                //Guarda registro id_edificio
                                $tipo_edificio = $fila[2];
                                $id_edificio = $fila[0];
                                //Obtener nombre del edificio actual en la lista
                                  $query = "SELECT obtener_nombre_edificio ('".$tipo_edificio."')";
                                  $res = pg_query($conexion,$query); 
                                  $row = pg_fetch_row($res);
                                  $nombre_edificio = $row[0];
                                echo "
                                <label>
                                  <input type=\"radio\" name=\"id_edificio\" value=\"".$id_edificio."\">
                                  ".$nombre_edificio."</label>
                                <br>
                                ";
                              }

                              echo "<br>
                                    <input type=\"number\" id=\"ingresoNivelASubirEdificio\" name=\"nivel\" class=\"form-control\" placeholder=\"Cantidad de niveles a subir...\" required autofocus>
                                    <br>
                                    ";
                          //Termina form
                        }
                        else{
                             echo "No se puede mostrar datos porque no hay conexión con la base de datos<br>";
                        }
                      ?>
                    </div>
                    <div class="modal-footer">
                      <button type="submit" class="btn btn-primary">
                        Subir nivel</button>
                      <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                    </div>
                  </form>";
                </div>
              </div>
            </div> 


<!-- --------------------------------------------------------------------------------------------------------------------------------------- -->   
<!-- Modal Información de clan-->

            <div class="modal fade" id="modalClan" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
    
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Información de Clan</h4>
                  </div>
    
                  <div class="modal-body">

                  <?php
                      if($conexion)
                      {
                        if($id_clan)
                        {
                          
                          //Obtener datos del clan del jugador
                          $query = "SELECT * FROM clan WHERE (id_clan = '".$id_clan."')";
                          $result2 = pg_query($conexion,$query);   
                          $fila = pg_fetch_row($result2);
                          $nombre_clan = $fila[3];

                          $exp_clan = $fila[2];
                          $cant_miembros_clan = $fila[1];

                          echo "<li>Nombre: <strong>".$nombre_clan."<br></li></strong>
                          <li>Experiencia del clan: <strong>".$exp_clan."<br></li></strong>
                          <li>Cantidad de miembros: <strong>".$cant_miembros_clan."<br></li></strong>
                          <li>ID única del clan: <strong>".$id_clan."<br></li></strong><br>

                          <li>Miembros de tu clan:</li><br>

                          <table class=\"table\" cellspacing=1 border=1>
                            <thead>
                              <tr>
                                <th>Nombre</th>
                                <th>ID</th>
                                <th>Experiencia</th>

                              </th>
                            </thead>
                            <tbody>
                              
                          ";

                          //Obtener miembros del clan
                          $query = "SELECT * FROM jugador WHERE (id_clan = '".$id_clan."');";
                          $result = pg_query($conexion,$query);
                          $num_filas = pg_num_rows($result);
                          
                          while($col= pg_fetch_row($result)){
                                echo "<tr>";
                                // Se obtiene la ID de la unidad de la fila actual
                                
                                echo "<td>".$col[1]." ".$col[2]."</td>";
                                echo "<td>".$col[0]."</td>";
                                echo "<td>".$col[6]."</td>";
                                echo "</tr>";
                          }
                          echo "</tbody>
                          </table>";

                          // Eliminación de clan
                          echo "<br>
                                <button type=\"button\" onclick=\"confirmacionSalidaClan()\" class=\"btn btn-primary\">
                                Salirme del clan</button>
                                <br>
                                ";
                        }
                        else
                        {
                          echo "<li>No estás en ningún clan :( </strong><br><br></li>
                                <button type=\"button\" class=\"btn btn-primary\" data-toggle=\"modal\" data-target=\"#modalCrearClan\">
                                Crear Clan</button><br>
                                <hr>
                                O si quieres puedes unirte a uno existente...<br><br>
                                <form class=\"form-inline\" action=\"unirseClan.php\" method=\"POST\">
                                  <div class=\"form-group\">
                                    <input type=\"text\" id=\"ingresoNombreClan\" name=\"nombre_clan\" class=\"form-control\" placeholder=\"Nombre de Clan...\" required autofocus>
                                  </div>
                                  <button type=\"submit\" class=\"btn btn-primary\">
                                    Unirse a este clan</button>
                                </form>
                                ";   
                        }
                      }
                    ?>

                    <!-- Script para confirmación al salirse del clan -->
                    <script>
                    function confirmacionSalidaClan() {
                        if (confirm("¿Estás seguro que deseas salirte del clan?") == true) {
                            window.location.assign("salirClan.php");
                        }
                    }</script>

                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                  </div>
                </div>
              </div>
            </div> 

<!-- --------------------------------------------------------------------------------------------------------------------------------------- -->   
<!-- Modal Creación de clan-->

            <div class="modal fade" id="modalCrearClan" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
    
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Creación de clan</h4>
                  </div>
    
                  <div class="modal-body">
                    <?php
                      if($conexion)
                      {
                        echo "Ingresar nombre del clan... <br><br>
                              <form class=\"form-inline\" action=\"crearClan.php\" method=\"POST\">
                                <div class=\"form-group\">
                                  <input type=\"text\" id=\"ingresoNombreClanCrear\" name=\"nombre_clan\" class=\"form-control\" placeholder=\"Nombre de Clan...\" required autofocus>
                                </div>
                                <button type=\"submit\" class=\"btn btn-primary\">
                                Crear este clan!</button>
                                </form>
                              ";
                      }
                    ?>
                      
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                  </div>
                </div>
              </div>
            </div> 

<!-- --------------------------------------------------------------------------------------------------------------------------------------- -->              
<!-- Modal Agregar Saldo-->

            <div class="modal fade" id="modalAgregarSaldo" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Agregar Saldo</h4>
                  </div>
                    <form action="modificarSaldo.php" method="POST">
                      <div class="modal-body">
                      
                        <p>
                          <label>
                            <input type="radio" name="saldo" value="1000" id="saldo_0">
                            $1000</label>
                          <br>
                          <label>
                            <input type="radio" name="saldo" value="2000" id="saldo_1">
                            $2000</label>
                          <br>
                          <label>
                            <input type="radio" name="saldo" value="3000" id="saldo_2">
                            $3000</label>
                          <br>
                          <label>
                            <input type="radio" name="saldo" value="4000" id="saldo_3">
                            $4000</label>
                          <br>
                          <label>
                            <input type="radio" name="saldo" value="5000" id="saldo_4">
                            $5000</label>
                          <br>
                          <label>
                            <input type="radio" name="saldo" value="10000" id="saldo_5">
                            $10000</label>
                          <br>
                          <label>
                            <input type="radio" name="saldo" value="20000" id="saldo_6">
                            $20000</label>
                          <br>
                          <label>
                            <input type="radio" name="saldo" value="50000" id="saldo_7">
                            $50000</label>
                          <br>
                          <label>
                            <input type="radio" name="saldo" value="100000" id="saldo_8">
                            $100000</label>
                          <br>

                        </p>
                      </div>
                      <div class="modal-footer">
                        <!-- Button trigger modal Modificar Datos Personales -->
                        <button type="submit" class="btn btn-primary">
                          Agregar Saldo
                        </button>
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                      </div>
                  </form>
                </div>
              </div>
            </div>


<!-- --------------------------------------------------------------------------------------------------------------------------------------- -->  
<!-- Modal Comprar Edificios-->

            <div class="modal fade" id="modalComprarEdificios" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content"> 
                  <div class="modal-header">
                    <h4 class="modal-title" id="myModalLabel">Comprar edificios</h4>
                  </div>
                  <form action="verificarCompraEdificio.php" method="POST">
                    <div class="modal-body">

                      <p>
                          <label>
                            <input type="radio" name="tipo_edificio" value="1" id="tipo_cuartelOscuro">
                            Cuartel Oscuro</label>
                          <br>
                          <label>
                            <input type="radio" name="tipo_edificio" value="2" id="tipo_cuartel">
                            Cuartel</label>
                          <br>
                          <label>
                            <input type="radio" name="tipo_edificio" value="3" id="tipo_campamento">
                            Campamento</label>
                          <br>
                          <label>
                            <input type="radio" name="tipo_edificio" value="4" id="tipo_caldero">
                            Caldero de Hechizos</label>
                          <br>
                          <label>
                            <input type="radio" name="tipo_edificio" value="5" id="tipo_altar">
                            Altar del rey Barbaro</label>
                          <br>
    
                        <div class="form-group">
                          <label for="ingresoCantidadEdificios">Cantidad: </label>
                          <input type="number" id="ingresoCantidadEdificios" name="cant" class="form-control" placeholder="Cantidad" ng-model="cant" required autofocus>
                        </div>
                        <div class="form-group">
                          <label for="ingresoNivelEdificio">Nivel del Edificio: </label>
                          <input type="number" id="ingresoNivelEdificio" name="nivel" class="form-control" placeholder="Nivel" ng-model="nivel" required autofocus>
                        </div>
                      
                    </div>
                    <div class="modal-footer">
                      <!-- Button trigger modal -->
                      <button type="submit" class="btn btn-primary">
                        Comprar
                      </button>
                      <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                    </div>
                  </form>
                </div>
              </div>
            </div>

<!-- --------------------------------------------------------------------------------------------------------------------------------------- -->  
<!-- Modal Comprar Unidades-->

            <div class="modal fade" id="modalComprarUnidades" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content"> 
                  <div class="modal-header">
                    <h4 class="modal-title" id="myModalLabel">Comprar unidades</h4>
                  </div>
                  <form action="verificarCompraUnidad.php" method="POST">
                    <div class="modal-body">

                      <p>
                          <label>
                            <input type="radio" name="tipo_unidad" value="1" id="tipo_barbaro">
                            Barbaro</label>
                          <br>
                          <label>
                            <input type="radio" name="tipo_unidad" value="2" id="tipo_arquero">
                            Arquero</label>
                          <br>
                          <label>
                            <input type="radio" name="tipo_unidad" value="3" id="tipo_gigante">
                            Gigante</label>
                          <br>
    
                        <div class="form-group">
                          <label for="ingresoCantidadUnidades">Cantidad: </label>
                          <input type="number" id="ingresoCantidadUniades" name="cant" class="form-control" placeholder="Cantidad" ng-model="cant" required autofocus>
                        </div>
                      
                    </div>
                    <div class="modal-footer">
                      <!-- Button trigger modal -->
                      <button type="submit" class="btn btn-primary">
                      <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                        Comprar
                      </button>
                    </div>
                  </form>
                </div>
              </div>
            </div>

<!-- --------------------------------------------------------------------------------------------------------------------------------------- -->  
<!-- Modal Bandeja de Entrada-->

            <div class="modal fade" id="modalMensajes" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
    
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Mensajes</h4>
                  </div>
    
                  <div class="modal-body">

                  <?php
                        if($conexion)
                        {
                          //Tabla mensajes enviados
                          $query = "SELECT * FROM msj WHERE (id_emisor = '".$id."');";
                          $result = pg_query($conexion,$query);
                          $num_filas = pg_num_rows($result);
                          echo "<strong>Mensajes enviados:</strong><br><br>";

                          echo "
                          <table class=\"table\" cellspacing=1 border=1>
                            <thead>
                              <tr>
                                <th>Destinatario</th>
                                <th>Fecha</th>
                                <th>Mensaje</th>
                              </th>
                            </thead>
                            <tbody>
                              
                          ";
                          
                          while($col= pg_fetch_row($result)){
                                echo "<tr>";
                                // Se obtiene la ID de la unidad de la fila actual
                                
                                echo "<td>".$col[4]."</td>";
                                echo "<td>".$col[2]."</td>";
                                 echo "<td>".$col[1]."</td>";
                                echo "</tr>";
                          }
                          echo "</tbody>
                          </table>";

                          //Tabla Mensajes recibidos
                          $query = "SELECT * FROM msj WHERE (id_receptor = '".$id."');";
                          $result = pg_query($conexion,$query);
                          $num_filas = pg_num_rows($result);
                          echo "<strong>Mensajes Recibidos:</strong><br><br>";

                          echo "
                          <table class=\"table\" cellspacing=1 border=1>
                            <thead>
                              <tr>
                                <th>Emisor</th>
                                <th>Fecha</th>
                                <th>Mensaje</th>
                              </th>
                            </thead>
                            <tbody>
                              
                          ";
                          
                          while($col= pg_fetch_row($result)){
                                echo "<tr>";
                                // Se obtiene la ID de la unidad de la fila actual
                                
                                echo "<td>".$col[3]."</td>";
                                echo "<td>".$col[2]."</td>";
                                 echo "<td>".$col[1]."</td>";
                                echo "</tr>";
                          }
                          echo "</tbody>
                          </table>";
                        }
                        else{
                           echo "No se puede mostrar datos porque no hay conexión con la base de datos<br>";
                        }
                      ?>
                      
                  </div>
                  <div class="modal-footer">
                    <!-- Button trigger modal Redactar Mensaje-->
                    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#modalRedactarMensaje">
                      Redactar Mensaje
                    </button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                  </div>
                </div>
              </div>
            </div>    

<!-- --------------------------------------------------------------------------------------------------------------------------------------- -->  
<!-- Modal Redactar Mensaje-->

            <div class="modal fade" id="modalRedactarMensaje" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
    
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Redactar Mensaje</h4>
                  </div>
                  <form action="mensaje.php" method="POST">
                    <div class="modal-body">
                      <div class="form-group">
                        <label for="ingresoDestinatarioMensaje">Para: </label>
                        <input type="text" id="ingresoDestinatarioMensaje" name="destinatario" class="form-control" placeholder="Destinatario..." required autofocus>
                      </div>
                      <div class="form-group">
                        <label for="ingresoMensaje">Mensaje: </label>
                        <textarea type="text" id="ingresoMensaje" name="mensaje" class="form-control" placeholder="Escribir mensaje..." required autofocus rows="5"></textarea>
                      </div>
                    </div>
                    <div class="modal-footer">
                      <button type="submit" class="btn btn-primary">
                          Enviar Mensaje
                      </button>
                      <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                    </div>
                  </form>
                </div>
              </div>
            </div> 

<!-- --------------------------------------------------------------------------------------------------------------------------------------- -->  
<!-- Modal Ataque-->

            <div class="modal fade" id="modalAtaque" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
    
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Realizar ataque</h4>
                  </div>
                  <form action="ataque.php" method="POST">
                    <div class="modal-body">
                      <div class="form-group">
                        <label for="ingresoDestinatarioAtaque">Para: </label>
                        <input type="text" id="ingresoDestinatarioAtaque" name="id_victima" class="form-control" placeholder="Destinatario del ataque..." required autofocus>
                      </div>
                      <div class="form-group">
                        <label for="ingresoCantidadUnidades">Cantidad Unidades a enviar al ataque: </label>
                        <input type="number" id="ingresoCantidadUnidades" name="cantidad" class="form-control" placeholder="Cantidad Unidades..." required autofocus>
                      </div>
                    </div>
                    <div class="modal-footer">
                      <button type="submit" class="btn btn-primary">
                        Enviar Ataque
                      </button>
                      <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                    </div>
                  </form>
                </div>
              </div>
            </div>  

<!-- --------------------------------------------------------------------------------------------------------------------------------------- -->  
<!-- FIN MODALES -->
            
            <?php
              // Guardar datos extras de sesión actual
              $_SESSION["id"] = $id;
              $_SESSION["id_aldea"] = $id_aldea;
              $_SESSION["exp"] = $expTotal;

              //Cierra cualquier conexión abierta a la base de datos
              pg_close($conexion);
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