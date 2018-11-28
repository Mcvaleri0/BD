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

            case "evento":
                echo("
                <h3>Associar processo a evento</h3>
                <form action='assoc.php?target=evento' method='post'>
                    <input type='hidden' name='submited' value='yes'/>
                    <table class='dados'>
                        <tr>  <td> <b> Processo de Socorro: <b> </td> </tr>
                        <tr> <td> <label>N&uacutemero do Processo:</label> </td> <td> <input type='text' name='numProcessoSocorro'/> </td> </tr>
                        <tr> <td> <br/> </td> </tr>
                        <tr>  <td> <b> Evento de Emerg&ecircncia: <b> </td> </tr>
                        <tr> <td> <label>Instante da chamada:     </label> </td> <td> <input style='width:173px' type='datetime-local' step='1' name='instanteChamada'/>    </td> </tr>
                        <tr> <td> <label>N&uacutemero de telefone:</label> </td> <td> <input type='text' name='numTelefone'/>        </td> </tr>
                       
                    </table>
                    <br/>
                    <input type='submit' value='Submit' id='submit'/>
                </form>
                ");

                if($submited == "yes"){

                    $db->beginTransaction();

                    $prep = $db->prepare("UPDATE EventoEmergencia
                                          SET numProcessoSocorro = :numProcessoSocorro
                                          WHERE (numTelefone = :numTelefone AND instanteChamada = :instanteChamada)");  
                    
                    $prep->bindParam(':numTelefone',        $_REQUEST['numTelefone']);

                    $instanteChamada    = $_REQUEST['instanteChamada'];
                    $instanteChamada    = date("d-m-Y H:i:s",strtotime($instanteChamada));
                    $prep->bindParam(':instanteChamada',    $instanteChamada);

                    $prep->bindParam(':numProcessoSocorro', $_REQUEST['numProcessoSocorro']);
                 
                    $prep->execute();

                    $db->commit();
                    $db   = null;
                    $prep = null;
                }

            break;

            case "meio":
                echo("
                <h3>Associar processo a meio</h3>
                <form action='assoc.php?target=meio' method='post'>
                    <input type='hidden' name='submited' value='yes'/>
                    <table class='dados'>
                        <tr>  <td> <b> Processo de Socorro: <b> </td> </tr>
                        <tr> <td> <label>N&uacutemero do Processo:</label> </td> <td> <input type='text' name='numprocessosocorro'/> </td> </tr>
                        <tr> <td> <br/> </td> </tr>
                        <tr>  <td> <b> Meio: <b> </td> </tr>
                        <tr> <td> <label>N&uacutemero do Meio:</label> </td> <td> <input type='text' name='nummeio'/>      </td> </tr>
                        <tr> <td> <label>Nome da Entidade:    </label> </td> <td> <input type='text' name='nomeentidade'/> </td> </tr>
                    </table>
                    <br/>
                    <input type='submit' value='Submit' id='submit'/>
                </form>
                ");

                if($submited == "yes"){
               
                    $db->beginTransaction();

                    $prep = $db->prepare(" INSERT INTO Acciona VALUES( :nummeio, :nomeentidade, :numprocessosocorro);");  

                    $prep->bindParam(':numprocessosocorro', $_REQUEST['numprocessosocorro']);
                    $prep->bindParam(':nummeio',            $_REQUEST['nummeio']);
                    $prep->bindParam(':nomeentidade',       $_REQUEST['nomeentidade']);
                    $prep->execute();


                    $db->commit();
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


