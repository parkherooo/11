package find;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailService {

    // 이메일 전송 (여러 서비스 지원)
    public static boolean sendEmail(String emailService, String from, String fromName, String password, String recipient, String subject, String content) {
        Properties props = new Properties();
        
        // 이메일 서비스에 따른 SMTP 설정
        switch (emailService.toLowerCase()) {
            case "gmail":
                props.put("mail.smtp.host", "smtp.gmail.com");
                props.put("mail.smtp.port", "587");
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                break;
            case "naver":
                props.put("mail.smtp.host", "smtp.naver.com");
                props.put("mail.smtp.port", "587");
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                break;
            case "nate":
                props.put("mail.smtp.host", "smtp.mail.nate.com");
                props.put("mail.smtp.port", "465");
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.ssl.enable", "true");
                break;
            case "outlook":
                props.put("mail.smtp.host", "smtp-mail.outlook.com");
                props.put("mail.smtp.port", "587");
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                break;
            default:
                System.out.println("지원하지 않는 이메일 서비스입니다.");
                return false;
        }

        // 이메일 세션 설정
        Session mailSession = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(from, fromName));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
            message.setSubject(subject);
            message.setText(content);

            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
