package sjls.todotalk.user.controller;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import sjls.todotalk.user.service.AllSearchService;
import sjls.todotalk.user.service.ChatRoomService;
import sjls.todotalk.user.vo.RoomVo;
import sjls.todotalk.user.vo.UserVo;


@Controller
public class ChatController {
	
	@Autowired
	AllSearchService allSearchService;
	
	@Autowired
	ChatRoomService chatRoomService;
	
	
	@RequestMapping(value="/AllSearch", method=RequestMethod.GET)
	public ModelAndView allSearch(String query) {
		String queryString = query;
		ModelAndView mav = new ModelAndView();
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("queryString", queryString);	//검색어 mapping
		//튜터 검색결과 반환
		List<UserVo> tutorVo = allSearchService.getTutorList(map);
		int tutorVoSize = tutorVo.size();
		System.out.println("튜터검색결과 : "+tutorVo);
		//멘토 검색결과 반환
		List<UserVo> mentorVo = allSearchService.getMentorList(map);
		System.out.println("멘토검색결과 : "+mentorVo);
		int mentorVoSize = mentorVo.size();
		//게시판 검색결과 반환
		List<HashMap<String, Object>> boardAllSearch = allSearchService.getBoardList(map);
		System.out.println("게시판검색결과 :"+boardAllSearch);
		int boardAllSearchSize = boardAllSearch.size();
//		System.out.println(map.size());
//		System.out.println(boardAllSearch.get(0));
		
		mav.addObject("tutorVo",tutorVo);
		mav.addObject("tutorVoSize",tutorVoSize);
		mav.addObject("mentorVo",mentorVo);
		mav.addObject("mentorVoSize",mentorVoSize);
		mav.addObject("boardAllSearch",boardAllSearch);
		mav.addObject("boardAllSearchSize",boardAllSearchSize);
		mav.setViewName("/allSearch");
		
		return mav;		
	}
	@RequestMapping(value="/talk", method= {RequestMethod.POST, RequestMethod.GET}) 
	public String talk (HttpServletRequest request,HttpServletResponse response, Model model){	
		String receiverId = request.getParameter("receiverId");
		String requireId = request.getParameter("requireId");
		
		Object chatRooms = new HashMap<String,RoomVo>();
		chatRooms = chatRoomService.findAllRoom();
		
		//방이 현재 roomList에 없으면 만든다. DB 없으면 추가한다. 
		RoomVo roomVo = chatRoomService.createRoomById(receiverId,requireId);			
		model.addAttribute("room", roomVo);
		return "room";
	}
	
											//다음 할일  : 대화 db저장 -> 창닫기 인식 또는 나가기 버튼 클릭 시
											//창닫기가 onClose로 인식되도록 바꾸기. 그리고 onClose에 DB저장 수식 넣기
											//채팅창에 DB 불러오기 및 스크롤 지정하기
	
	
	@RequestMapping("/rooms")
	public String rooms (Model model) {
		Object chatRooms = new HashMap<String,RoomVo>();
		chatRooms = chatRoomService.findAllRoom();
		model.addAttribute("rooms",chatRooms);						//개설된 모든 대화방을 찾아서 rooms에 입력
		//System.out.println("넘어온 값 : "+chatRoomRepository.findAllRoom()); 확인
		
		return "rooms";
	}
}