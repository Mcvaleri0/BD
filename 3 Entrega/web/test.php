<html>
    <body>
<?php
    try
    {
        include 'login.php';

        $db = null;
    }
    catch (PDOException $e)
    {
        echo("<p>ERROR: {$e->getMessage()}</p>");
    }
?>
        

    </body>
</html>
