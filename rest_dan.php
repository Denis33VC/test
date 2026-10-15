<?php
require_once('../lib/functions.php');
$conn = my_connect();

$sql_rest = "select date_part('seconds',now()-max(mydate)) as seconds_part from public.workshop_statuses";
$kol_rest = getCell($sql_rest, 0, 0);

if ((int) $kol_rest > 15) {

	$array1 = makeRequest(getRest() . '/api/tags');
	$array2 = makeRequest(getRest() . '/api/workshops');
	$array3 = makeRequest(getRest() . '/api/workshop-statuses');

	for ($i = 0; $i < count($array1); $i++) {
		$tagID = $array1[$i]->tagID;
		$tagType = $array1[$i]->tagType;
		$tagBatch = $array1[$i]->tagBatch;
		$tagDate = date('d.m.Y', strtotime($array1[$i]->tagDate));
		$tagManufacturer = $array1[$i]->tagManufacturer;
		$tagCountry = $array1[$i]->tagCountry;
		$carNumber = $array1[$i]->carNumber;

		$sql1 = "select count(*) as kol from public.tags where tagid='$tagID'";;
		$kol1 = getCell($sql1, 0, 0);
		if ($kol1 == 0) {
			$sql2 = "insert into public.tags(mydate,tagid,tagtype,tagbatch,tagdate,tagmanufacturer,tagcountry,carnumber)
				values(now(),'$tagID','$tagType','$tagBatch',to_date('$tagDate','dd.mm.yyyy'),'$tagManufacturer','$tagCountry','$carNumber')";
			exe($sql2);
		}
	}

	for ($i = 0; $i < count($array2); $i++) {
		$workshopNumber = $array2[$i]->workshopNumber;
		$workshopName = $array2[$i]->workshopName;
		$workshopManager = $array2[$i]->workshopManager;
		$readerID = $array2[$i]->readerID;
		$readerNumber = $array2[$i]->readerNumber;

		$sql1 = "select count(*) as kol from public.workshops where workshopnumber='$workshopNumber'";
		$kol1 = getCell($sql1, 0, 0);
		if ($kol1 == 0) {
			$sql2 = "insert into public.workshops(mydate,workshopnumber,workshopname,workshopmanager,readerid,readernumber)
	        values(now(),'$workshopNumber','$workshopName','$workshopManager','$readerID','$readerNumber')";
			exe($sql2);
		}
	}

	for ($i = 0; $i < count($array3); $i++) {
		$workshopNumber = $array3[$i]->workshopNumber;
		$tagID = $array3[$i]->tagID;

		$sql = "insert into public.workshop_statuses(mydate,workshopnumber,tagid)
	        values(now(),'$workshopNumber','$tagID')";
		exe($sql);
	}
}
