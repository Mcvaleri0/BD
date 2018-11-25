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

            case "allprocessos":
                $db->beginTransaction();

                $sql = "SELECT * FROM processosocorro;";
                $result = $db->prepare($sql);
                $result->execute();
                
                echo("<div id = 'container'>");
                echo("<table class='list'>\n");
                echo("<tr id='top'><td>numprocessosocorro</td></tr>\n");
                foreach($result as $row)
                {
                    echo("<tr><td>");
                    echo($row['numprocessosocorro']);
                    echo("</td></tr>\n");
                }
                echo("</table>\n");
                echo("</div>");
            
                $db->commit();
                $db   = null;

            break;

            case "allmeios":

                $db->beginTransaction();

                $sql = "SELECT * FROM Meio;";
                $result = $db->prepare($sql);
                $result->execute();
                
                echo("<div id = 'container'>");
                echo("<table class='list'>\n");
                echo("<tr id='top'><td>nummeio</td><td>nomemeio</td><td>nomeentidade</td></tr>\n");
                foreach($result as $row)
                {
                    echo("<tr><td>");
                    echo($row['nummeio']);
                    echo("</td><td>");
                    echo($row['nomemeio']);
                    echo("</td><td>");
                    echo($row['nomeentidade']);
                    echo("</td></tr>\n");
                }
                echo("</table>\n");
                echo("</div>");
                
                $db->commit();
                $db   = null;
                

            break;

            case "meiosaccionados":
                echo("
                <h3>Listar meios accionados</h3>
                <form action='list.php?target=meiosaccionados' method='post'>
                    <input type='hidden' name='submited' value='yes'/>
                    <table class='dados'>
                        <tr> <td> <label>N&uacutemero do Processo:</label> </td> <td> <input type='text' name='numProcessoSocorro'/> </td> </tr>
                    </table>
                    <br/>
                    <input type='submit' value='Submit' id='submit'/>
                    <br/>
                </form>
                ");

                if($submited == "yes"){
                    $db->beginTransaction();
                    
                    $sql = "SELECT * 
                            FROM (
                                Meio NATURAL JOIN (
                                    SELECT * FROM Acciona 
                                    WHERE numProcessoSocorro = :numProcessoSocorro
                                ) AS MeiosAccionados
                            );";

                    $result = $db->prepare($sql);
                    $result->bindParam(':numProcessoSocorro',$_REQUEST['numProcessoSocorro']);
                    $result->execute();

                    echo("<div id = 'container'>");
                    echo("<table class='list'>\n");
                    echo("<tr id='top'><td>nummeio</td><td>nomemeio</td><td>nomeentidade</td></tr>\n");
                    foreach($result as $row)
                    {
                        echo("<tr><td>");
                        echo($row['nummeio']);
                        echo("</td><td>");
                        echo($row['nomemeio']);
                        echo("</td><td>");
                        echo($row['nomeentidade']);
                        echo("</td></tr>\n");
                    }
                    echo("</table>\n");
                    echo("</div>");
                    
                    $db->commit();
                    $db   = null;
                }
            break;

            case "m_socorroaccionadoslocal":
                echo("
                <h3>Listar meios de Socorro accionados em local</h3>
                <form action='list.php?target=m_socorroaccionadoslocal' method='post'>
                    <input type='hidden' name='submited' value='yes'/>
                    <table class='dados'>
                        <tr> <td> <label>N&uacutemero do Processo:</label> </td> <td> <input type='text' name='numProcessoSocorro'/> </td> </tr>
                        <tr> <td> <label>Local:</label> </td> <td> <input type='text' name='moradaLocal'/> </td> </tr>
                    </table>
                    <br/>
                    <input type='submit' value='Submit' id='submit'/>
                    <br/>
                </form>
                ");

                if($submited == "yes"){
                    $db->beginTransaction();

                    $sql = "SELECT * 
                        FROM MeioSocorro NATURAL JOIN Acciona NATURAL JOIN EventoEmergencia
                        WHERE numProcessoSocorro = :numProcessoSocorro AND moradaLocal = :moradaLocal";

                    $result = $db->prepare($sql);
                    $result->bindParam(':numProcessoSocorro',$_REQUEST['numProcessoSocorro']);
                    $result->bindParam(':moradaLocal',$_REQUEST['moradaLocal']);
                    $result->execute();

                    echo("<div id = 'container'>");
                    echo("<table class='list'>\n");
                    echo("<tr id='top'><td>nummeio</td><td>nomeentidade</td></tr>\n");
                    foreach($result as $row)
                    {
                        echo("<tr><td>");
                        echo($row['nummeio']);
                        echo("</td><td>");
                        echo($row['nomeentidade']);
                        echo("</td></tr>\n");
                    }
                    echo("</table>\n");
                    echo("</div>");
                    
                    $db->commit();
                    $db   = null;
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
    
    #container{
     
        display:    inline-block;
        overflow:   auto;
        max-height: 90%;
        min-width:  355px;
    }

    #top{
        background-color:  rgb(230, 230, 230);
        font-weight: bold;
    }
    table.list th,table.list td {
        border: 2px solid rgb(179, 179, 179);
        padding: 3px;
        
    }

    .list {
        border-collapse: collapse;
        border: 1px solid black;
        width: 100%;
    }

    .dados{
        width: 370px;
        table-layout:fixed;
        border: none;
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


