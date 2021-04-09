<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../layout/header.jsp"%>

<script>
	$(function(){
		
		mentorSearch();
		
		//인풋창에서 Enter치면 mentorSearch 메소드 실행
		$("#mentorSearch").keydown(function(key){
			if(key.keyCode == 13){
				mentorSearch();
			}
		})
		
		
		$(document).on('click', '.detail-info', function(event){
			event.preventDefault();
			$.ajax({
				url : '/detailInfo',
				type : 'POST',
				data : {
					userid : $("#mentorid").val()
				},
				success : function(result){
					$("#mentor_name").html(result.mentorInfo.USER_NAME);
					$("#mentor_id").html(result.mentorInfo.USER_ID);
					$("#mentor_phone").html(result.mentorInfo.USER_PHONE);
					$("#mentor_country").html(result.mentorInfo.COUNTRY);
					$("#mentor_mail").html(result.mentorInfo.USER_MAIL);
					$("#mentor_recommend").html(result.mentorInfo.RECOMMEND);
					$("#mentor_address").html(result.mentorInfo.ADDRESS);
					$("#mentor_introduce").html(result.mentorInfo.INTRODUCE);
				},
				error : function(xhr){
					alert(xhr.status + ", " + xhr.statusText);
				}
			})
		});
		
		
	});
	
	function mentorSearch(){
		$.ajax({
			url : '/mentorSearchFm',
			type : 'POST',
			data : {
				mentorSearch : $("#mentorSearch").val()
			},
			success : function(result){
				
				//인사말의 길이가 10 이상이면 그 이후의 문자들을 "..." 처리
				for(var i = 0; i < result.mentorList.length; i++){
					if(result.mentorList[i].INTRODUCE.length >= 10){
						result.mentorList[i].INTRODUCE = result.mentorList[i].INTRODUCE.substr(0, 10)+" ...";
					}
				}
				//href="/detailInfo?userid='+item.RECEIVER_ID+'"
				var data = result.mentorList;
				var html = "";
				if(data != ""){
					$.each(data, function(index, item){
						html += '<div class="mentor-info">';
						html +=  '<ul>';
						html +=  	'<li>이름 : '+item.USER_NAME+'</li>';
						html +=  	'<li>국적 : '+item.COUNTRY+'</li>';
						html +=  	'<li>인사말 : '+item.INTRODUCE+'</li>';
						html +=  	'<input type="hidden" name="userid" value="'+item.RECEIVER_ID+'" id="mentorid">';
						html +=  '</ul>';
						html +=  '<ul>';
						html +=    '<li><a href="#" title="상세보기" class="detail-info"><img src="../img/common/btn-search.png"></a></li>';
						html +=    '<li><a href="#" title="메세지보내기" class="message"><img src="../img/common/ico_mail.png"></a></li>';
						html +=  '</ul>';
						html += '</div>';
						$("#list").html(html);
					});
			  }else{
				  html += '<p style="text-align:center; font-size:16px;">해당하는 멘토가 없습니다.</p>';
				  $("#list").html(html);
			  }
			},
			error : function(xhr){
				alert(xhr.status + ", " + xhr.statusText);
			}
		})
	}
	
	
</script>
    <div class="sub-main-wrap">
        <%@include file="../layout/leftMenu.jsp"%>
        <div class="sub-container-wrap">
            <%@include file="../layout/allSearchHeader.jsp"%>
            <div class="middle-content-wrap2 mentorMenteePage">
                <!--여기부터 컨텐츠내용 작업시작-->
               	<div class="search-box">
               		<input type="text" id="mentorSearch" name="mentorSearch" class="mentor-search" placeholder="멘토이름, 국적 검색">
               		<a href="javascript:mentorSearch()" title="검색" class="btn-search3"></a>
               	</div>
               	<div class="list-wrap">
	               	<div id="list"></div>
               	</div>
            </div>
            <footer>
                <div class="sub-footer">
                    <p></p>
                    <p>시스템관리자</p>
                    <p>todotalk@gmail.com <span class="red fs13">(수정할 수 없는 항목에 오류가 있는 경우는 시스템 관리사에게 해당메일로 수정 요청을 해주시기 바랍니다.)</span></p>
                </div>
            </footer>
        </div>
        <!--//sub-container-wrap-->
    </div>
    <!--//sub-main-wrap-->
    <div class="modal-wrap" id="modal">
            <div class="modal-bg"></div>
            <div class="modal-container">
                <div class="modal-header">
                    <h4>멘토정보</h4>
                    <a href="#" title="닫기" class="btn-close" id="btn-close"></a>
                </div>
                <div class="modal-contents">
                    <div class="modal-contents-box">
                        <div class="table-wrap">
                            <table class="table-type02">
                                <caption>멘토정보 테이블</caption>
                                <colgroup>
                                    <col class="wp15">
                                    <col class="wp15">
                                    <col class="wp15">
                                    <col class="wp15">
                                </colgroup>
                                <tbody>
                                	<tr>
	                                	<th>이름</th>
	                                	<td id="mentor_name"></td>
	                                	<th>아이디</th>
	                                	<td id="mentor_id"></td>
                                	</tr>
                                	<tr>
	                                	<th>전화번호</th>
	                                	<td id="mentor_phone"></td>
	                                	<th>국적</th>
	                                	<td id="mentor_country"></td>
                                	</tr>
                                	<tr>
	                                	<th>메일</th>
	                                	<td id="mentor_mail"></td>
	                                	<th>추천 수</th>
	                                	<td id="mentor_recommend"></td>
                                	</tr>
                                	<tr>
	                                	<th>주소</th>
	                                	<td colspan="3" id="mentor_address"></td>
                                	</tr>
                                	<tr>
	                                	<th>인사말</th>
	                                	<td colspan="3" id="mentor_introduce"></td>
                                	</tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-btn-box">
                        <ul>
                            <li>
                                <a href="#" title="취소" class="btn-cancel" id="btn-cancel">닫기</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div> <!-- //modal-picture-->
</body>

</html>
