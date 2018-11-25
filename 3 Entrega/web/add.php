<html>
    <body style="font-family:Helvetica; font-size: 16px;">
   
    <!--back button-->
    <div class ="back" onclick="window.location.href='index.html'"> &#9666 Back</div>
    
<?php
    try
    {
        include 'login.php';
        
        //if flags are set, request them otherwise start them empty 
        $submited = isset($_REQUEST['submited']) ? $_REQUEST['submited'] : '';
        $target = isset($_REQUEST['target']) ? $_REQUEST['target'] : '';

        switch($target){

            case "local":
                echo("
                <h3>Inserir novo Local</h3>
                <form action='add.php?target=local' method='post'>
                    <input type='hidden' name='submited' value='yes'/>
                    <table class='dados'>
                        <tr> <td> <label>Nome do Local:</label> </td> <td> <input type='text' name='moradaLocal'/> </td> </tr>
                    </table>
                    <br/>
                    <input type='submit' value='Submit' id='submit'/>
                </form>
                ");

                if($submited == "yes"){

                    $prep = $db->prepare("INSERT INTO Local VALUES(:moradaLocal);");

                    $prep->bindParam(':moradaLocal', $_REQUEST['moradaLocal']);
                    $prep->execute();
                    
                    $db   = null;
                    $prep = null;
                }

            break;

            case "evento":
                echo("
                <h3>Inserir novo Evento de Emerg&ecircncia</h3>
                <form action='add.php?target=evento' method='post'>
                    <input type='hidden' name='submited' value='yes'/>
                    <table class='dados'>
                        <tr> <td> <label>Instante da chamada:     </label> </td> <td> <input style='width:173px' type='datetime-local' step='1' name='instanteChamada'/>    </td> </tr>
                        <tr> <td> <label>N&uacutemero de telefone:</label> </td> <td> <input type='text' name='numTelefone'/>        </td> </tr>
                        <tr> <td> <label>Nome da Pessoa:          </label> </td> <td> <input type='text' name='nomePessoa'/>         </td> </tr>
                        <tr> <td> <label>Local:                   </label> </td> <td> <input type='text' name='moradaLocal'/>        </td> </tr>
                        <tr> <td> <label>N&uacutemero do Processo:</label> </td> <td> <input type='text' name='numProcessoSocorro'/> </td> </tr>
                    </table>
                    <br/>
                    <input type='submit' value='Submit' id='submit'/>
                </form>
                ");

                if($submited == "yes"){

                    $instanteChamada    = $_REQUEST['instanteChamada'];
                    $instanteChamada    = date("d-m-Y H:i:s",strtotime($instanteChamada));

                    $prep = $db->prepare("INSERT INTO EventoEmergencia VALUES(:numTelefone, :instanteChamada, :nomePessoa, :moradaLocal, :numProcessoSocorro);");
                    
                    $prep->bindParam(':numTelefone',        $_REQUEST['numTelefone']);
                    $prep->bindParam(':nomePessoa',         $_REQUEST['nomePessoa']);
                    $prep->bindParam(':moradaLocal',        $_REQUEST['moradaLocal']);
                    $prep->bindParam(':numProcessoSocorro', $_REQUEST['numProcessoSocorro']);
                    $prep->bindParam(':instanteChamada',    $instanteChamada);
                    $prep->execute();

                    $db   = null;
                    $prep = null;
                }

            break;


            case "processo":
                echo("
                <h3>Inserir novo Processo de Socorro</h3>
                <form action='add.php?target=processo' method='post'>
                    <input type='hidden' name='submited' value='yes'/>
                    <table class='dados'>
                        <tr> <td> <label>N&uacutemero do Processo:</label> </td> <td> <input type='text' name='numProcessoSocorro'/> </td> </tr>
                    </table>
                    <br/>
                    <input type='submit' value='Submit' id='submit'/>
                </form>
                ");

                if($submited == "yes"){

                    $prep = $db->prepare("INSERT INTO ProcessoSocorro VALUES(:numProcessoSocorro);");
                    $prep->bindParam(':numProcessoSocorro', $_REQUEST['numProcessoSocorro']);
                    $prep->execute();

                    $db   = null;
                    $prep = null;
                }

            break;

            case "entidade":
                echo("
                <h3>Inserir nova Entidade</h3>
                <form action='add.php?target=entidade' method='post'>
                    <input type='hidden' name='submited' value='yes'/>
                    <table class='dados'>
                        <tr> <td> <label>Nome da Entidade:</label> </td> <td> <input type='text' name='nomeentidade'/> </td> </tr>
                    </table>
                    <br/>
                    <input type='submit' value='Submit' id='submit'/>
                </form>
                ");

                if($submited == "yes"){
                    $prep = $db->prepare("INSERT INTO EntidadeMeio VALUES(:nomeentidade);");
                    $prep->bindParam(':nomeentidade', $_REQUEST['nomeentidade']);
                    $prep->execute();
                    
                    $db   = null;
                    $prep = null;
                }

            break;

            case "meio":
                echo("
                <h3>Inserir novo Meio</h3>
                <form action='add.php?target=meio' method='post'>
                    <input type='hidden' name='submited' value='yes'/>
                    <table class='dados'>
                        <tr> <td> <label>N&uacutemero do Meio:</label> </td> <td> <input type='text' name='nummeio'/>      </td> </tr>
                        <tr> <td> <label>Nome do Meio:        </label> </td> <td> <input type='text' name='nomemeio'/>     </td> </tr>
                        <tr> <td> <label>Nome da Entidade:    </label> </td> <td> <input type='text' name='nomeentidade'/> </td> </tr>
                    </table>
                    <br/>
                    <input type='submit' value='Submit' id='submit'/>
                </form>
                ");

                if($submited == "yes"){
               
                    $prep = $db->prepare("INSERT INTO Meio VALUES(:nummeio, :nomemeio, :nomeentidade);");
                    $prep->bindParam(':nummeio',      $_REQUEST['nummeio']);
                    $prep->bindParam(':nomemeio',     $_REQUEST['nomemeio']);
                    $prep->bindParam(':nomeentidade', $_REQUEST['nomeentidade']);
                    $prep->execute();

                    $db   = null;
                    $prep = null;
                }

            break;

            case "m_combate":
            case "m_apoio":
            case "m_socorro":
                
                //get tabela certa
                if($target == "m_combate"){
                    $tabelaMeio = "MeioCombate";
                    echo("<h3>Inserir novo Meio de Combate</h3>
                          <form action='add.php?target=m_combate' method='post'>");
                }
                else if($target == "m_apoio"){
                    $tabelaMeio = "MeioApoio";
                    echo("<h3>Inserir novo Meio de Apoio</h3>
                    <form action='add.php?target=m_apoio' method='post'>");
                }
                else{
                    $tabelaMeio = "MeioSocorro";
                    echo("<h3>Inserir novo Meio de Socorro</h3>
                    <form action='add.php?target=m_socorro' method='post'>");
                }

                echo("
                    <input type='hidden' name='submited' value='yes'/>
                    <table class='dados'>
                        <tr> <td> <label>N&uacutemero do Meio:</label> </td> <td> <input type='text' name='nummeio'/>      </td> </tr>
                        <tr> <td> <label>Nome da Entidade:        </label> </td> <td> <input type='text' name='nomeentidade'/>     </td> </tr>
                    </table>
                    <br/>
                    <input type='submit' value='Submit' id='submit'/>
                </form>
                ");

                if($submited == "yes"){

                    $prep = $db->prepare("INSERT INTO $tabelaMeio VALUES(:nummeio, :nomeentidade);");

                    $prep->bindParam(':nummeio',      $_REQUEST['nummeio']);
                    $prep->bindParam(':nomeentidade', $_REQUEST['nomeentidade']);

                    $prep->execute();

                    $db   = null;
                    $prep = null;
                }

            break;

            default:
            break;
            
        }

    }
    catch (PDOException $e)
    {
        echo("<p>ERROR: {$e->getMessage()}</p>");
    }
?>

    </body>
</html>

<style>
    /*
    table, th, td {
        border: 1px solid black;
    }*/

    .dados{
        width: 370px;
        table-layout:fixed
    }

    input {
        float: left;
    }

    label {
        float: left;
    }

    #submit:hover{
        color: rgb(199, 0, 0);
    }

    .back{
        cursor: pointer; 
        font-size: 20px; 
        color: white; 
        background-color: rgb(179, 179, 179);
        width: 350px;
        user-select: none;
        padding: 5px;
        outline-style: auto;
    }

    .back:hover{
        background-color: rgb(151, 151, 151);
    }

    input::-webkit-outer-spin-button, /* Removes arrows */
    input::-webkit-inner-spin-button, /* Removes arrows */
    input::-webkit-clear-button { /* Removes blue cross */
        -webkit-appearance: none;
        margin: 0;
    }

</style>


