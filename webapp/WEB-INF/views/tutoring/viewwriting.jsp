<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../layout/header.jsp"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"  %>    
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script> 
	$(document).ready(function(){

 		$(document).on('submit','#replyForm', function(e){
 			e.preventDefault();
 			e.stopPropagation();
 			tureList();

 		}) //document.on
		
		function tureList(){
			var formData = $("#replyForm").serialize();
			$.ajax({
				url : '/postReply',
				type : 'POST',
				data : formData,
				success : function(result){
					var html			= '';
					html += '<div class="leftcolumn">';	// (result.replyList.menu_id 
					html += '<div class="card">';
					html += ' <h5>'+ result.tureVo[0].user_id +', ' + result.tureVo[0].tb_regdate + '</h5>';
					html += ' <p>' + result.tureVo[0].tb_repcont + '</p>';
					html += '</div>';
					html += '</div>';
					$("#newlyWrittenReply").append(html);
					
				},
				error : function(xhr){
					alert(xhr.status + ", " + xhr.statusText);
				}
				
				
			}); //ajax
		}
		
 	 	$(function () {
 		
			var cont = $("#cont").text();
	
		  	$("#tb_repcont").click(function(){
			  //alert($("#cont").text());
			  //alert(cont);
			
			  if( $("#tb_repcont").val() == "" ){
			   	$("#tb_repcont").append(cont);
			  } else {
				  
			  }
	
		  	});
 		
		}); //function
		
		
		var selectedCont = $('#cont').text();
		var contArray = selectedCont.split(' ');
		
		$.each(contArray, function (i, el){
			contArray[i] = $.trim(el);
		});
		
		$('#reply-list p').each(function(){
			if ($.inArray ($.trim ($(this).text()), 
					contArray) != 1) {
				$(this).addClass('highlight');
			}
		});
		
	}); //document.ready
</script>


<style>
	.highlight { background: yellow; }
	textarea { width: 700px; height: 300px; } 
</style>
    <div class="sub-main-wrap">
        <%@include file="../layout/leftMenu.jsp"%>
        <div class="sub-container-wrap">
            <%@include file="../layout/allSearchHeader.jsp"%>
            <div class="middle-content-wrap2">
                <!--여기부터 컨텐츠내용 작업시작-->
         
			<!-- 조회한 글 내용 -->
		  <table> 
		    <tr>
		      <td class="td1">글쓴이</td><br>
		    </tr>
		    <tr>
		      <td class="td2">${ tuboVo.user_id }</td>   
		    </tr> 
		    <tr>
		      <td class="td1">주제</td>
		    </tr>
		    <tr>
		      <td class="td5" colspan="3">${ tuboVo.tubo_title }</td>
		    </tr>
		    <tr>
		      <td class="td1">내용</td>
		    </tr>
		    <tr>
		      <td class="td5" id="cont" colspan="3">${ tuboVo.tubo_cont }</td>
		    </tr>  
		    <tr>
		      <td class="td3">날짜</td>
		    </tr>
		    <tr>
		      <td class="td4">${ tuboVo.tubo_regdate }</td>
		    </tr>    
<!-- 		    <tr>
		      <td colspan="4">
		       <input type="button" value="글수정"    id="btnUpdate"/>
		       <input type="button" value="글삭제"    id="btnDelete"/>
		      </td>
		    </tr> -->
		  </table>
		  <br>
 
				<!-- 댓글쓰는 폼 -->
 				<form name="replyForm" id="replyForm">
			   		<input type="hidden" name="user_idx"   		value="${ sessionScope.login.user_idx }" />     
			   		<input type="hidden" name="tubo_idx"   		value="${ tuboVo.tubo_idx }" />     
			   		<input type="hidden" name="tubo_regdate"    id = "tubo_regdate" value="${ tuboVo.tubo_regdate }" />     
					   <table id="writeTable">
						    <tr>
						    	<h2>첨삭 댓글 쓰기</h2>
						    </tr>
						    	<c:choose>
						         <c:when test="${ sessionScope.login.user_id eq null }">
						         	<tr>
						         	  <td><input type="text" name="guest"  id="guest"
						        		value="guest" readonly />
						        	  </td>
						        	</tr>
						        	<tr>
						        	  <td>
								      <input type="text" name="guest"  id="guest" 
								      	value="로그인 해주세요" readonly />
							          </td>
								    </tr> 
						        	
						         </c:when>
						         <c:otherwise>
						         	<tr>
								      <td><input type="text" name="user_id"  id="user_id"
								        value="${sessionScope.login.user_id}" readonly /> <!-- 로그인된 유저아이디  -->
								      </td>
								    </tr>
								    <tr>
								      <td><textarea name="tb_repcont" id="tb_repcont"></textarea></td>
								    </tr> 
								    <tr>      
								      <td colspan="2">
								        <button type="submit" id="submit"> 확인 </button>
								      </td>
								    </tr> 
						         </c:otherwise>
						        </c:choose>
					   </table> 
			  	</form>

		  		<div id="newlyWrittenReply">
		  		</div>


			<!-- 댓글 리스트 -->
		  	<c:forEach var="tureVo"  items="${ tureVo }">
		  	<div class="row">
		 		<div class="leftcolumn">
				    <div class="card" id="reply-list">
				      <h5>${tureVo.user_id}, ${tureVo.tb_regdate}</h5>
				      <p>${tureVo.tb_repcont}</p>
				    </div> 
		  		</div>
	  		</div>
		  	
		  	</c:forEach>
		  	
				<!--여기부터 컨텐츠내용 작업 끝-->
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
</body>

</html>