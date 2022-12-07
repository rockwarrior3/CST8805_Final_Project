
<?php
// Original code copied from w3schools.
// Adapted for CST8805 project by Yvan Perron November 27, 2021
//Do not change any of the code below this line and up to the "End of do not modify comment below"
$target_dir = "/home/kali/Downloads/";
$target_file = $target_dir . basename($_FILES["fileToUpload"]["name"]);
$target_fileSig = $target_dir . basename($_FILES["fileToUploadSig"]["name"]);
$target_fileX509 = $target_dir . basename($_FILES["fileToUploadX509"]["name"]);

$target_file = preg_replace('/[^a-zA-Z0-9\/\.]/', '', $target_file);
$target_fileSig = preg_replace('/[^a-zA-Z0-9\/\.]/', '', $target_fileSig);
$target_fileX509 = preg_replace('/[^a-zA-Z0-9\/\.]/', '', $target_fileX509);

$uploadOk = 1;

// Check if file already exists
//if (file_exists($target_file) || file_exists($target_fileSig) || file_exists($target_fileX509)) {
//  echo " <p>Files already exists - they will be overwritten. </p> ";
//  //$uploadOk = 0;
//}

echo " <p style='color:blue; font-size:1.5em;'> File Upload Results</p> ";

// Check file size
if ($_FILES["fileToUpload"]["size"] > 500000) {
  echo "<p style='color:red; font-size:1.5em;'>&nbsp &nbsp &nbsp Sorry, your file is too large.";
  $uploadOk = 0;
}

// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
  echo "<p style='color:red; font-size:1.5em;'>&nbsp &nbsp &nbsp Sorry, your file was not uploaded. </p>";
// if everything is ok, try to upload file
} else {
  if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file) && move_uploaded_file($_FILES["fileToUploadSig"]["tmp_name"], $target_fileSig) && move_uploaded_file($_FILES["fileToUploadX509"]["tmp_name"], $target_fileX509)) {
//    echo "The file ". htmlspecialchars( basename( $_FILES["fileToUpload"]["name"])). " and its digital signature have been uploaded. <br>";
      echo "<p style='color:green; font-size:1.5em;'>&nbsp &nbsp &nbsp Files successfully uploaded to Bank Payroll Application <br></p>";
  } else {
    echo "<p style='color:red; font-size:1.5em;'>&nbsp &nbsp &nbsp  Sorry, there was an error uploading your file.</p> ";
    $uploadOk = 0;
  }
}
//End of do NOT modify any of the code above this line

//The code below this line is student customizable
//Important variables
//  $target_fileSig    path to payroll signature file
//  $target_file       path to payroll file
//  $target_fileX509   path to signer x509 certificate
//  $target_filePub  path to signer public key

$target_filePubKey = $target_fileX509 . "_Pub.pem";

//Sample code - Signature Validation via OpenSSL command shell
if  ($uploadOk !== 0) {
//	$cmd = "openssl dgst -sha3-512 -verify rsa_pub_prof_sign.pem -signature ./uploads/Task1-msg-1-digsig.bin ./uploads/Task1-msg-1.txt ";
	//The openssl x509 command extracts the public key from the X509 certificate which is required in the signature verification step
	$cmd = "openssl x509 -inform pem -in $target_fileX509 -pubkey -out $target_filePubKey";
	$valRes = exec( $cmd );
	$cmd = "openssl dgst -sha256 -verify $target_filePubKey -signature $target_fileSig $target_file ";
  
  // Testing file against CRL
  $sign = "openssl verify -verbose -crl_check -CRLfile /var/www/html/server_files/CA_CRL.crl.pem -trusted /var/www/html/server_files/CA_Root.cer $target_fileX509";
  $valRes = shell_exec( $sign );
  $test = substr($valRes, strpos($valRes, ":") + 1); 
  $test_string = "OK";
  $test = trim($test);
  if ($test == "OK"){
    echo "<p style='color:green; font-size:1.5em;'>&nbsp &nbsp &nbsp CRL Verified</p>";
  }
  else{
    echo "<p style='color:red; font-size:1.5em;'>&nbsp &nbsp &nbsp CRL Rejected</p>";
    
  }
  // Checks validity of cert
  $sign = "openssl verify -verbose -CAfile /var/www/html/server_files/CA_Root.cer $target_fileX509 2>&1";
  $valRes = exec( $sign, $output );
  $output = substr($output[1], strpos($output[1], ":") + 1); 
  $test = substr($valRes, strpos($valRes, ":") + 1); 
  $test_string = "OK";
  $test = trim($test);
  if ($test == "OK"){
    echo "<p style='color:green; font-size:1.5em;'> &nbsp &nbsp &nbsp Certificate was signed by the proper CA</p>";
  }
  else {
    echo "<p style='color:red; font-size:1.5em;'>&nbsp &nbsp &nbsp Error: $output</p>";
    
  }
	echo " <p style='color:blue; font-size:1.5em;'> Payroll Signature Validation Results via shell_exec() method</p> ";
	$valRes = shell_exec( $cmd );
  $test = substr($valRes, strpos($valRes, " ") + 1); 
  if ($test == "failure"){
    echo "<p style='color:red; font-size:1.5em;'>&nbsp &nbsp &nbsp $valRes</p>";
  }
  else{
    echo "<p style='color:green; font-size:1.5em;'>&nbsp &nbsp &nbsp $valRes</p>";
    
  }
}

?>
