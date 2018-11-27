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

            case "m_combate":
            case "m_apoio":
            case "m_socorro":
                
                //get tabela certa
                if($target == "m_combate"){
                    $tabelaMeio = "MeioCombate";
                    echo("<h3>Editar Meio de Combate</h3>
                          <form action='edit.php?target=m_combate' method='post'>");
                }
                else if($target == "m_apoio"){
                    $tabelaMeio = "MeioApoio";
                    echo("<h3>Editar Meio de Apoio</h3>
                    <form action='edit.php?target=m_apoio' method='post'>");
                }
                else{
                    $tabelaMeio = "MeioSocorro";
                    echo("<h3>Editar Meio de Socorro</h3>
                    <form action='edit.php?target=m_socorro' method='post'>");
                }

                echo("
                    <input type='hidden' name='submited' value='yes'/>
                    <table class='dados'>
                        <tr> <td> <b>Dados antigos:<b> </td> <tr>
                        <tr> <td> <label>N&uacutemero do Meio:</label> </td> <td> <input type='text' name='nummeio'/>      </td> </tr>
                        <tr> <td> <label>Nome da Entidade:        </label> </td> <td> <input type='text' name='nomeentidade'/>     </td> </tr>
                        <tr> <td> <b>Nome novo:<b> </td> <tr>
                        <tr> <td> <label>Nome do Meio:        </label> </td> <td> <input type='text' name='nomemeio'/>     </td> </tr>
                    </table>
                    <br/>
                    <input type='submit' value='Submit' id='submit'/>
                </form>
                <br/>
                ");

                if($submited == "yes"){

                    $db->beginTransaction();

                    $test = $db->prepare("SELECT *
                                          FROM $tabelaMeio
                                          WHERE nummeio = :nummeio AND nomeentidade = :nomeentidade;");
                    
                    $test->bindParam(':nummeio',         $_REQUEST['nummeio']);
                    $test->bindParam(':nomeentidade',    $_REQUEST['nomeentidade']);
                    
                    $test->execute();

                    $num_rows = $test->rowCount();
                    if($num_rows > 0){
                        echo("Operation Successful");
                        $prep = $db->prepare("UPDATE Meio
                                              SET nomemeio = :nomemeio 
                                              WHERE nummeio = :nummeio AND nomeentidade = :nomeentidade;");

                        $prep->bindParam(':nomemeio',        $_REQUEST['nomemeio']);
                        $prep->bindParam(':nummeio',         $_REQUEST['nummeio']);
                        $prep->bindParam(':nomeentidade',    $_REQUEST['nomeentidade']);

                        $prep->execute();

                    }
                    else{
                        echo("ERROR: O meio que esta a tentar editar nao existe");
                    }

                    $db->commit();
                    
                    $db   = null;
                    $prep = null;
                    $test = null;
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


