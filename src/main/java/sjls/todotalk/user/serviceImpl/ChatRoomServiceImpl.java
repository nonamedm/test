package sjls.todotalk.user.serviceImpl;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import sjls.todotalk.user.dao.ChatDao;
import sjls.todotalk.user.service.ChatRoomService;
import sjls.todotalk.user.vo.MessageVo;
import sjls.todotalk.user.vo.MessageVo.MessageType;
import sjls.todotalk.user.vo.RoomVo;

@Service("chatRoomService")
public class ChatRoomServiceImpl implements ChatRoomService {
	
	private Map<String, RoomVo> chatRooms = new HashMap<String, RoomVo>();
	private List<HashMap<String,Object>> sessions = new ArrayList<>();
	
	@Autowired
	private ChatDao chatDao;
	
	@Override
	public RoomVo createRoomById(String id1, String id2) {
		System.out.println("중복검색할 id값 : "+id1 + "," + id2);
		RoomVo roomVo = new RoomVo();
		roomVo.setRoomId(UUID.randomUUID().toString());						//랜덤아이디 셋팅
		roomVo.setName(id1+id2);
		
		//개설한 채팅방 db에 저장 -> 개설된 적 있으면 roomId값 받아서 그대로 개설, 없으면 랜덤아이디로 새로 개설
		HashMap<String, Object> createRoom	 = new HashMap<String, Object>();
		createRoom.put("receiver_id", id1);
		createRoom.put("require_id", id2);
		String roomId = chatDao.findChatRoom(createRoom);				//대화자, 상대방 아이디로 개설된 방 있는지 먼저 조회(roomId값 리턴받음)
		if(roomId!=null) {
			
			createRoom.put("room_id", roomId);
			roomVo.setRoomId(roomId);
			chatRooms.put(roomVo.getRoomId(), roomVo);					//중복되면 안들어감
			System.out.println("chatRooms값 : "+chatRooms.values() );

		} else {
			
			createRoom.put("room_id", roomVo.getRoomId());
			chatDao.createChatRoom(createRoom);
			chatRooms.put(roomVo.getRoomId(), roomVo);					//조회된 값 없으면 방 개설 및 DB추가
		}
		
		return roomVo;
	}
	@Override
	public Object findAllRoom() {
		return chatRooms.values();
	}
	
	@Override
	public RoomVo findRoomById(String roomId) {
		return chatRooms.get(roomId);
	}

	@Override
	public void handleActions(WebSocketSession session, MessageVo messageVo, ObjectMapper objectMapper) {
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		if(messageVo.getType().equals(MessageType.ENTER)) {
			map.put("roomNumber", messageVo.getRoomId());
			map.put("session", session);
			sessions.add(map);
			
			messageVo.setMessage(messageVo.getSender() + " 님이 입장하셨습니다.");
			
		} else if (messageVo.getType().equals(MessageType.LEAVE)) {
			
			map.put("roomNumber",messageVo.getRoomId());
			map.put("session",session);
			sessions.remove(map);						// 나갈때 그 세션 지운다
			//방은 어차피 세션 리셋되면 리셋 되는거고... 아니라도 추가 생성 안되니까 굳이 지우지 말자
			messageVo.setMessage(messageVo.getSender() + " 님이 퇴장하셨습니다.");
			System.out.println("남은 세션 수 : "+sessions.size());
			
		} else {
			messageVo.setMessage(messageVo.getSender()+" : "+messageVo.getMessage());
		}
		try {
			TextMessage textMessage = new TextMessage(objectMapper.writeValueAsString(messageVo.getMessage()));		// 
			String roomNumber = messageVo.getRoomId(); //지금 메세지 보낸 사람의 방번호 : messageVo.getRoomId();
			for (int i = 0; i < sessions.size(); i++) {
				// 메세지 가야 할 방번호 : for문 돌려서 이거랑 같은 곳 모두 보내기
				if(roomNumber.equals(sessions.get(i).get("roomNumber"))) {
					//System.out.println( "세션 출력테스트 : "+sessions.get(i).get("session")); 확인
					WebSocketSession sess = (WebSocketSession) sessions.get(i).get("session");
					sess.sendMessage(textMessage);
				}
			}
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}