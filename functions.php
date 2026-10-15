<?php
// Подгружаемые функции во все файлы PHP

/** Создание соединения */
function my_connect()
{
    $fileData =  file_get_contents('../php/appconfig.json');
    $dan = json_decode($fileData);

    $host_dan = $dan->host;
    $port_dan = $dan->port;
    $dbname_dan = $dan->dbname;
    $user_dan = $dan->user;
    $password_dan = $dan->password;

    // Формируем строку подключения
    $connection_string = "host={$host_dan} port={$port_dan} dbname={$dbname_dan} user={$user_dan} password={$password_dan}";

    // Пытаемся установить соединение
    $dbconn = @pg_connect($connection_string);
    $conn = $dbconn; // $conn - используется в функциях (привычно по работе)

    // Проверяем, удалось ли подключение
    // if (!$dbconn) {
    //     // echo "Не удалось подключиться к базе данных PostgreSQL: " . @pg_last_error(); // Вывод сообщения об ошибке стандартными средствами PHP
    //     output('red', 'Не удалось подключиться к базе данных PostgreSQL.' /*. @pg_last_error()*/); // Функция functions.php
    //     die;
    // }
    return $conn;
}

// Получение адреса REST API
function getRest()
{
    $fileData =  file_get_contents('../php/appconfig.json');
    $dan = json_decode($fileData);
    return $dan->rest;
}

function makeRequest($url){
	// Инициализируем новый сеанс с CURL
	$curl = curl_init($url);

	// При неудачном сеансе - выходим
	if ($curl === false) return false;

	// Задаем параметр для сеанса: возврат ответа в виде строки, а не напрямую в браузер
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);

	// Выполнение запроса и запись резултата
	$result = curl_exec($curl);

	// Закрытие сеанса
	curl_close($curl);

	// Передаем массив PHP, конвектируемый из JSON-формата
	return json_decode($result);
}

function msg_print($msg, $check = true)
{
    if ($check == true) {
        global $conn;
        pg_query($conn, "rollback;"); // отменяем все изменения в БД по текущему запросу
        pg_close($conn);
    }
    die("<br><br><br><br><br><center><h1><font color='red'><b>$msg</b></font></h1></center>");
}

/** Выход из PHP с ошибкой.
 * 
 * @param global $conn подключение к БД
 * @param global $sql последний запрос к БД
 * @return null нет возвращаемых данных
 */
function exeption()
{
    global $conn, $sql;
    $str = json_encode(array('success' => 'red', 'msg' => @pg_last_error($conn), 'sql' => $sql));
    pg_query($conn, "rollback;"); // отменяем все изменения в БД по текущему запросу
    pg_close($conn);
    die($str);
}jdkhjhgkjdf

/** Выполнение запроса (insert/update/delete).
 * 
 * @param string $sql запрос к БД
 * @param global $conn подключение к БД
 * @return null нет возвращаемых данных
 */
function exe($sql)
{
    global $conn;
    $res = @pg_query($conn, $sql);
    if (!$res) {
        exeption();
    }
}

/** Получить массив из БД.
 * 
 * @param string $sql запрос к БД
 * @param string $print если true, то запрос при открытии PDF/Excel в новом окне
 * @param global $conn подключение к БД
 * @return array возвращаем массив данных
 */
function getArray($sql, $print = false)
{
    global $conn, $print_msg;
    $res = @pg_query($conn, $sql);
    if (!$res) {
        if ($print == false) {
            exeption();
        } else {
            msg_print($print_msg);
        }
    }
    return pg_fetch_all($res);
}

/** Получить значение одной ячейки из БД.
 * 
 * @param string $sql запрос к БД
 * @param int $row порядковый номер строки (по умолчанию = 0)
 * @param int $cell порядковый номер столбца (по умолчанию = 0)
 * @param global $conn подключение к БД
 * @return mixed возвращаем значение из БД по выбранным строке и ячейке
 */
function getCell($sql, $row = 0, $cell = 0)
{
    global $conn;
    $res = @pg_query($conn, $sql);
    if (!$res) {
        exeption();
    }
    if (!($row = @pg_fetch_row($res))) {
        output('red', 'Не удалось получить значение.');
    }
    return $row[$cell];
}

/** Убираем из строки дублирующиеся и пустые значения.
 * @param string $string_in строка для преобразования
 * @param string $sym_in знак разделитель (на входе)
 * @param string $sym_out знак разделитель (на выходе)
 * @return $string_out возвращает строку без лишних элементов
 */
function php_filter_string($string_in = "", $sym_in = ';', $sym_out = '; ')
{
    if ($string_in != "") {
        $string_out = "";
        $arr = explode($sym_in, $string_in);
        $arr = array_map('trim', $arr);
        $arr = array_filter($arr);
        $arr = array_unique($arr);
        $string_out = implode($arr, $sym_out);
    } else {
        $string_out = "";
    }
    return $string_out;
}

/** Преобразуем строку в массив и убираем из него дублирующиеся и пустые значения.
 * @param string $string_in строка для преобразования
 * @param string $sym_in знак разделитель (на входе)
 * @param string $sym_out знак разделитель (на выходе)
 * @return $arr_out возвращает массив без лишних элементов
 */
function php_string_to_array($string_in = "", $sym_in = ';', $sym_out = '; ')
{
    $string_out = php_filter_string($string_in, $sym_in, $sym_out);
    $arr_out = explode($sym_out, $string_out);
    return $arr_out;
}

/** Выход из PHP с уведомлением.
 * 
 * @param mixed $code код ответа или цвет сообщения
 * @param string $msg текст сообщения
 * @param array $items выходной массив данных
 * @param global $conn подключение к БД
 * @param global $sql последний запрос к БД
 * @return null нет возвращаемых данных
 */
function output($code, $msg = 'Ошибка при выполнении запроса!', $items = array())
{
    global $conn, $sql;
    if ((float) $code == (float) 1 || (string) $code == (string) 'green' || (float) $code == (float) 2 || (string) $code == 'blue') {
        $sql = "commit;";
    } else {
        $sql = "rollback;";
    }
    exe($sql);
    pg_close($conn);
    $str = json_encode(array('success' => $code, 'msg' => $msg, 'items' => $items, 'sql' => $sql));
    die($str);
}

/** Расстановка переносов для запросов SQL
 * 
 * @param mixed $text получаем строку
 * @return string возвращаем измененную строку $text
 */
function where_or_and($text)
{
    if ($text == "") {
        $text .= " WHERE ";
    } else {
        $text .= " AND ";
    }
    return $text;
}

// Отправить JSON в JS
function sendJson($_msg, $_table, $_no_limit = false, $_start = 0, $_limit = 100)
{
    $_items = array();
    // постраничная выгрузка
    if ($_no_limit == false) {
        $_end = $_start + $_limit;
        if ($_end > count($_table)) {
            $_end = count($_table);
        } // если строк выгрузки меньше $limit
        for ($qq = $_start; $qq < $_end; $qq++) {
            array_push($_items, $_table[$qq]);
        }
    }
    // выгрузка без ограничение по LIMIT
    else {
        $_items = $_table;
    }
    die(json_encode(array('success' => 2, 'msg' => $_msg, 'totalCount' => count($_table), 'items' => $_items)));
}


/** Функция для преобразования месяца в текстовый формат
 * 
 * @mes - месяц в виде числа
 * @$t - в каком падеже текст: и - именительный, в - винительный
 */
function my_get_month($mes, $t = 'в')
{
    switch ($mes) {
        case 1:
            $name = "январ";
            if ($t == 'в') {
                $name .= "я";
            } else if ($t == 'и') {
                $name .= "ь";
            }
            break;
        case 2:
            $name = "феврал";
            if ($t == 'в') {
                $name .= "я";
            } else if ($t == 'и') {
                $name .= "ь";
            }
            break;
        case 3:
            $name = "март";
            if ($t == 'в') {
                $name .= "а";
            } else if ($t == 'и') {
                $name .= "";
            }
            break;
        case 4:
            $name = "апрел";
            if ($t == 'в') {
                $name .= "я";
            } else if ($t == 'и') {
                $name .= "ь";
            }
            break;
        case 5:
            $name = "ма";
            if ($t == 'в') {
                $name .= "я";
            } else if ($t == 'и') {
                $name .= "й";
            }
            break;
        case 6:
            $name = "июн";
            if ($t == 'в') {
                $name .= "я";
            } else if ($t == 'и') {
                $name .= "ь";
            }
            break;
        case 7:
            $name = "июл";
            if ($t == 'в') {
                $name .= "я";
            } else if ($t == 'и') {
                $name .= "ь";
            }
            break;
        case 8:
            $name = "август";
            if ($t == 'в') {
                $name .= "а";
            } else if ($t == 'и') {
                $name .= "";
            }
            break;
        case 9:
            $name = "сентябр";
            if ($t == 'в') {
                $name .= "я";
            } else if ($t == 'и') {
                $name .= "ь";
            }
            break;
        case 10:
            $name = "октябр";
            if ($t == 'в') {
                $name .= "я";
            } else if ($t == 'и') {
                $name .= "ь";
            }
            break;
        case 11:
            $name = "ноябр";
            if ($t == 'в') {
                $name .= "я";
            } else if ($t == 'и') {
                $name .= "ь";
            }
            break;
        case 12:
            $name = "декабр";
            if ($t == 'в') {
                $name .= "я";
            } else if ($t == 'и') {
                $name .= "ь";
            }
            break;
    }
    return $name;
}

// =============== ПЕЧАТЬ ===============

/** Проверка на наличие символов в строке */
function getSpace($tmp_members)
{
    if ($tmp_members == '') {
        return '';
    } else {
        return '; ';
    }
}

/** Разбиваем членов комиссии на строки */
function getMembers($check, $page = 1)
{
    $tmp_check = $check;
    $tmp_com_array = array();
    $tmp_index = -1;

    // 1 страница
    if ($page == 1) {
        $symb1 = 130;
        $symb2 = 215;
    }
    // 2 страница
    else {
        $symb1 = 270;
        $symb2 = 300;
    }

    for ($m = 0; $m < count($tmp_check); $m++) {
        if (
            empty($tmp_com_array[$tmp_index]) == true // если не найден элемент массива (первая итерация)
            || ((int) (strlen($tmp_com_array[$tmp_index]) + strlen($tmp_check[$m])) > (int) $symb1 && ($tmp_index == -1 || $tmp_index == 0)) // если в первой строке больше $symb1 символов
            || ((int) (strlen($tmp_com_array[$tmp_index]) + strlen($tmp_check[$m])) > (int) $symb2 && $tmp_index > 0) // если во 2 и последующих строках более $symb2 символов
        ) {
            $tmp_index++;
            $tmp_com_array[$tmp_index] = ""; // создаем новый элемент массива
        }
        if ($tmp_com_array[$tmp_index] != '') {
            $tmp_com_array[$tmp_index] .= ' ';
        } // если есть записи в текущей строке - ставим пробел
        $tmp_com_array[$tmp_index] .= $tmp_check[$m]; // добавляем слово в строку
    }
    return $tmp_com_array;
}

// ======================================

// Функции не используемые в текущей программе:

/** Преобразуем объект в массив перед отправкой в JS (нужно для предварительной загрузки страниц, например: xm185c01_before_load(...) {} ) */
function changeObjectToArray($obj)
{
    $items = array();
    foreach ($obj as $key => $val) {
        if (is_numeric($val)) {
            $val = (float) $val;
        }
        $items[] = array($key, $val);
    }
    return $items;
}

/** Принимает неограниченное количество переменных и выводит каждую через var_dump() и в конце прекращает выполнение скрипта */
function dd()
{
    $args = func_get_args();
    foreach ($args as $arg) {
        var_dump($arg);
        echo '<br>';
    }
    die;
}

/** Принимает неограниченное количество переменных и выводит каждую через var_dump() */
function d()
{
    $args = func_get_args();
    foreach ($args as $arg) {
        var_dump($arg);
    }
}

/** Получает массив без лишних элементов для обработки в PHP */
function getRecord($table, $start = 0, $limit = 100, $no_limit = false)
{
    $items = array();
    if ($no_limit == false) {
        $limit = $start + $limit;
        if ($limit > count($table)) {
            $limit = count($table);
        } // если строк выгрузки меньше $limit то грузим до последней строки
        for ($qq = $start; $qq < $limit; $qq++) {
            array_push($items, $table[$qq]);
        }
    } else {
        $items = $table;
    }
    return $items;
}

/** Обрезка незначащих нулей */
function cut($value)
{
    return $value === null ? '' : rtrim(rtrim(number_format($value, 6, '.', ''), '0'), '.');
}

/** Преобразование формата при выгрузке чисел (выгружать в формат string) */
function num_to_str($value, $round = 6, $space = '')
{
    return number_format($value, $round, ',', $space);
}

/** Замена символов которые не получается вывести на печать */
function repl_text($text)
{
    $text = str_replace('"', "'", $text);
    return $text;
}

/** Преобразование формата даты в другой вид.
 * Принимает $date в виде ГГГГ-ММ-ДД, возвращает в виде ДД.ММ.ГГГГ
 */
function tmp_function_check_date($date)
{
    if (preg_match("/^([0-9]{4})-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/", $date, $regs)) {
        // var_dump($regs);
        $new_date = $regs[3] . "." . $regs[2] . "." . $regs[1];
        return $new_date;
    } else {
        return "Недопустимый формат даты (ДД-ММ-ГГГГ): $date";
    }
}


/** Получение данных из GET и POST (без необходимости проверять откуда пришли данные) */
function get_php_params_from_js()
{
    // Массив для хранения данных
    $requestData = array();
    // Проверяем и добавляем данные из $_POST
    if (!empty($_POST)) {
        foreach ($_POST as $key => $value) {
            $requestData[$key] = $value;
        }
    }
    // Проверяем и добавляем данные из $_GET
    if (!empty($_GET)) {
        foreach ($_GET as $key => $value) {
            $requestData[$key] = $value;
        }
    }
    // Возвращаем массив с данными
    return $requestData;
}



/** Добавляет в массив столбец-счетчик для строк, по умолчанию 1 столбец: 'linenum'
 * 
 * @param array $_rows входной массив данных
 * @param array $_linenum_array входной массив со столбцами linenum, например: array('linenum_1','linenum_2')
 * @return $_items выходной массив
 */
function array_add_linenum($_items = array(), $_linenum_array = array('linenum'))
{
    $_linenum = 0;
    foreach ($_items as $_key => $_val) {
        $_linenum++;
        foreach ($_linenum_array as $_val) {
            $_items[$_key][$_val] = $_linenum;
        }
    }
    return $_items;
}



/** Определение окончания для текста, например для слово "строк" можно получить такие значения, как: строка, строки, строк
 * 
 * @param string $_number число от которого определяем окончание
 * @param string $_text слово к которому добавляем окончание, по умолчанию: "строк"
 * @return $_text возвращает окончание для текста
 */
function number_for_text($_number, $_text = 'строк')
{
    $last_two_digits = $_number % 100;
    $last_digit = $_number % 10;
    $symb_add = "";
    if ($last_two_digits >= 11 && $last_two_digits <= 19) {
        $symb_add .= "";
    } else if ($last_digit == 1) {
        $symb_add .= "а";
    } else if ($last_digit >= 2 && $last_digit <= 4) {
        $symb_add .= "и";
    } else {
        $symb_add .= "";
    }
    $_text .= $symb_add;
    return $_text;
}


/** Замена спецсимволов на символ "%". */
function replace_spec_symb_to_percent($_string)
{
    $_replace = array(
        '&' => '%',
        '<' => '%',
        '>' => '%',
        '"' => '%',
        "'" => '%',
        "«" => '%',
        "»" => '%'
    );
    return str_replace(array_keys($_replace), $_replace, $_string);
}

/** Замена спецсимволов на закодированное значение для правильной выгрузки через XSL:FO */
function replace_for_xslfo($_string)
{
    $_replace = array(
        '&' => '&amp;',
        '<' => '&lt;',
        '>' => '&gt;',
        '"' => '&quot;',
        "'" => '&apos;'
    );
    return str_replace(array_keys($_replace), $_replace, $_string);
}
