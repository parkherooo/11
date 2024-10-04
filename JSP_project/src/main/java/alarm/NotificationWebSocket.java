package alarm;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint("/alarm/notifications")
public class NotificationWebSocket {

    // WebSocket에 연결된 클라이언트 세션 저장소
    private static Set<Session> clients = new CopyOnWriteArraySet<>();

    // 클라이언트가 WebSocket에 연결되었을 때 실행
    @OnOpen
    public void onOpen(Session session) {
        clients.add(session);
        System.out.println("[DEBUG] 클라이언트 연결됨: " + session.getId() + ", 현재 연결된 클라이언트 수: " + clients.size());
    }

    // 클라이언트가 연결을 종료했을 때 실행
    @OnClose
    public void onClose(Session session) {
        clients.remove(session);
        System.out.println("[DEBUG] 클라이언트 연결 해제: " + session.getId() + ", 남은 클라이언트 수: " + clients.size());
    }

    // 클라이언트로부터 메시지를 받았을 때 실행
    @OnMessage
    public void onMessage(String message, Session session) {
        System.out.println("[DEBUG] 클라이언트로부터 받은 메시지: " + message + " (Session ID: " + session.getId() + ")");
    }

    // 서버에서 클라이언트로 실시간 알림을 전송하는 메소드
    public static void sendNotification(String notification) {
        System.out.println("[DEBUG] 서버에서 알림 전송 시작: " + notification);
        for (Session client : clients) {
            if (client.isOpen()) {
                try {
                    client.getBasicRemote().sendText(notification);
                    System.out.println("[DEBUG] 알림 전송 성공: " + notification + " (Session ID: " + client.getId() + ")");
                } catch (IOException e) {
                    System.err.println("[ERROR] 알림 전송 실패 (Session ID: " + client.getId() + "): " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                System.out.println("[DEBUG] 클라이언트 세션이 닫혀 있음: " + client.getId());
            }
        }
    }
}
