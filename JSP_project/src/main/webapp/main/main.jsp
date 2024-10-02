<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/main.css">
<script>
    document.addEventListener('DOMContentLoaded', () => {
        let currentSlide = 0;
        const slides = document.querySelectorAll('.slide-content');
        const totalSlides = slides.length;

        function showSlide(index) {
        	// 모든 슬라이드를 숨기고 해당 인덱스의 슬라이드를 보여줌
            slides.forEach(slide => slide.classList.remove('active'));
            slides[index].classList.add('active');
            
         	// 슬라이드 번호 업데이트
            document.querySelector('.current-slide').textContent = index + 1; // 슬라이드 인덱스는 0부터 시작하므로 +1
            document.querySelector('.total-slides').textContent = totalSlides; // 전체 슬라이드 수 업데이트
        }

        function nextSlide() {
            currentSlide = (currentSlide + 1) % totalSlides;
            showSlide(currentSlide);
        }

        function prevSlide() {
            currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
            showSlide(currentSlide);
        }

        // 이벤트 리스너 추가
        document.querySelector('.left-arrow').addEventListener('click', prevSlide);
        document.querySelector('.right-arrow').addEventListener('click', nextSlide);

     	// 처음에 첫 슬라이드와 슬라이드 번호 표시
        showSlide(currentSlide);
    });
</script>
<%@ include file="header.jsp" %>
</head>
<body class="main-body">
	
    <!-- 메인 콘텐츠 섹션 -->
    <section class="main-content">
        <!-- 왼쪽 화살표 -->
        <div class="arrow left-arrow">
            <img src="../img/arrow.png" alt="Left Arrow">
        </div>
        
        <!-- 슬라이드 내용 -->
        <div class="slide-content active">
        	<img src="../img/양배추롤.jpg" alt="양배추롤">
            <h2>양배추롤</h2>
            <p>부드러운 아보카도와 신선한 토마토가 어우러진 상큼한 샐러드</p>
        </div>
        <div class="slide-content">
        	<h2>그린 샐러드</h2>
        	<p>신선한 야채가 가득한 그린 샐러드</p>
    	</div>
        <!-- 오른쪽 화살표 -->
        <div class="arrow right-arrow">
            <img src="../img/arrow.png" alt="Right Arrow">
        </div>
        <!-- 슬라이드 네비게이션 -->
    	<div class="slider-nav">
        	<span class="current-slide">1</span>
        	<div class="line"></div>
        	<span class="total-slides">10</span>
    	</div>
	</section>
	<%@ include file="../chatbot/chatbot.jsp" %>
	<footer>
		<%@ include file="footer.jsp" %>
	</footer>
</body>
</html>