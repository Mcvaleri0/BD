<html>
    <body>
<?php
    try
    {
        #-----login-----
        $host = "db.ist.utl.pt";
        $user ="ist186419";
        $password = "Francisco12safe";
        $dbname = $user;
        
        
        $db = new PDO("pgsql:host=$host;dbname=$dbname", $user, $password);
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        #---------------
        
        $sql = "SELECT * FROM processosocorro;";
        $result = $db->prepare($sql);
        $result->execute();

        echo("<table border=\"1\">\n");
        echo("<tr><td>numprocessosocorro</td></tr>\n");
        foreach($result as $row)
        {
            echo("<tr><td>");
            echo($row['numprocessosocorro']);
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
