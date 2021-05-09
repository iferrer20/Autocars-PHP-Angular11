
<?php


$a = 1;
$x = array();
$x[] = &$a;
$x[] = &$a;

$x[1] = 2;

echo $x[0];
echo $x[1];

?>
