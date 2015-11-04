<?php
function getRowForFile($file,$title,$bundle_id,$server_path) {
	$maxmb = 10000;

    date_default_timezone_set('America/Toronto');

	$fsizebytes = filesize($server_path . "/" . $file);
	$fsize      = round($fsizebytes / 1048576, 1);
	$ip         = $_SERVER["HTTP_HOST"];
	$vhost_name = "";

	if (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== off) {
		$protocol = "https";
	}
	else {
		$protcol = "http";
	}

	$ipa_url      = $protocol . "://" . $ip . "/" . $vhost_name . "/". $file;
	$manifest_url = urlencode($protocol . "://" . $ip . "/" . $vhost_name . "/manifest.php?title=" . $title . "&bundle_id=" . $bundle_id . "&ipa=" . $ipa_url);
	$url          = "itms-services://?action=download-manifest&url=" . $manifest_url;

	if ($fsize >= $maxmb) {
		$fsizecolor = "red";
	}
	else {
		$fsizecolor = "black";
	}

	$res = "<tr><td><a href='" . $url . "'>" . str_replace(".ipa","",$file) . "</a></td><td>" . date('Y-m-d, H:i', filemtime($file)) . "</td><td><font color='" . $fsizecolor . "'>" . $fsize . "</font></td></tr>";

	return $res;
}

function getAndroidRowForFile($file,$title,$bundle_id) {
	$maxmb = 10000;

    date_default_timezone_set('America/Toronto');

	$fsizebytes = filesize($file);

	$fsize = round($fsizebytes / 1048576, 1);

	if ($_SERVER['SERVER_NAME'] == "getsetgames.com") {
		$apk_url = "http://" . $_SERVER['SERVER_NAME'] . "/archived-builds/" . $file;
	}
	else {
		$apk_url = "http://" . $_SERVER['SERVER_NAME'] ."/". $file;
	}

	if ($fsize >= $maxmb) {
		$fsizecolor = "red";
	}
	else {
		$fsizecolor = "black";
	}

	$res = "<tr><td><a href='" . $apk_url . "'>" . str_replace(".apk","",$file) . "</a></td><td>" . date('Y-m-d, H:i', filemtime($file)) . "</td><td><font color='" . $fsizecolor . "'>" . $fsize . "</font></td></tr>";

	return $res;
}

function getWin32RowForFile($file,$title,$bundle_id) {
	$maxmb = 10000;

    date_default_timezone_set('America/Toronto');

	$fsizebytes = filesize($file);

	$fsize = round($fsizebytes / 1048576, 1);

	if ($_SERVER['SERVER_NAME'] == "getsetgames.com") {
		$apk_url = "http://" . $_SERVER['SERVER_NAME'] . "/archived-builds/" . $file;
	}
	else {
		$apk_url = "http://" . $_SERVER['SERVER_NAME'] ."/". $file;
	}

	if ($fsize >= $maxmb) {
		$fsizecolor = "red";
	}
	else {
		$fsizecolor = "black";
	}

	$res = "<tr><td><a href='" . $apk_url . "'>" . str_replace(".zip","",$file) . "</a></td><td>" . date('Y-m-d, H:i', filemtime($file)) . "</td><td><font color='" . $fsizecolor . "'>" . $fsize . "</font></td></tr>";

	return $res;
}
?>
