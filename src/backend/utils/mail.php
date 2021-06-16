<?php

namespace Utils;

class Mail {
    public static string $email;
    public static string $name;
    static function send_mail($to_email, $subject, $html) {
        $ch = curl_init();

        $message = json_encode([
				'Messages' => [
					0 => [
						'From' => [
							'Email' => self::$email,
							'Name' => self::$name,
						],
						'To' => [
							0 => [
								'Email' => $to_email,
							],
						],
						'Subject' => $subject,
						'HTMLPart' => $html,
					],
				],
			]);
        curl_setopt($ch, CURLOPT_URL, 'https://api.mailjet.com/v3.1/send');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $message);
        curl_setopt($ch, CURLOPT_USERPWD, '19d47730c9e42cd7d4b8884155951a10' . ':' . '2da7e9eb9e15f6ad8f8f1832daa59821');

        $headers = array();
        $headers[] = 'Content-Type: application/json';
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

        $result = curl_exec($ch);
        if (curl_errno($ch)) {
            echo 'Error:' . curl_error($ch);
        }
        curl_close($ch);

    }
}

Mail::$email = \Utils\get_json('mail')->email;
Mail::$name = \Utils\get_json('mail')->name;
?>
