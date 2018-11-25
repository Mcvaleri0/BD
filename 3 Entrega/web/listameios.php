<html>
    <body>
        <!--back button-->
        <div class ="back" onclick="window.location.href='index.html'"> &#9666 Back</div>
<?php
    try
    {
        include 'login.php';
        
        $sql = "SELECT * FROM Meio;";
        $result = $db->prepare($sql);
        $result->execute();

        echo("<table border=\"1\">\n");
        echo("<tr><td>nummeio</td><td>nomemeio</td><td>nomeentidade</td></tr>\n");
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
    
        $db = null;
    }
    catch (PDOException $e)
    {
        echo("<p>ERROR: {$e->getMessage()}</p>");
    }
?>
        

    </body>
</html>

<style>

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

</style>