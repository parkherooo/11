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
        const banner = document.querySelector('.banner');

     	// 배너의 초기 배경색을 투명으로 설정
	    banner.style.backgroundColor = 'transparent';

		// 배너에 마우스를 올렸을 때
        banner.addEventListener('mouseenter', () => {
            banner.style.backgroundColor = 'white';
        });

        // 배너에서 마우스를 내렸을 때
        banner.addEventListener('mouseleave', () => {
            if (window.scrollY > 50) {
                banner.style.backgroundColor = 'white'; // 스크롤이 50px 이상일 때
            } else {
                banner.style.backgroundColor = 'transparent'; // 스크롤이 50px 미만일 때
            }
        });
     	
        // 스크롤 시 배너 이벤트
        window.addEventListener('scroll', () => {
            if (window.scrollY > 50) { // 스크롤 위치가 50px 이상일 때
                banner.style.backgroundColor = 'white';
                banner.style.transition = 'background-color 0.3s ease'; // 부드럽게 변환
            } else {
                banner.style.backgroundColor = 'transparent'; // 원래 배경 투명
            }
        });
        
        function showSlide(index) {
        	slides.forEach((slide, i) => {
                if (i === index) {
                    slide.classList.add('active');
                } else {
                    slide.classList.remove('active');
                }
            });
        	
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

        <div class="arrow left-arrow">
            <img src="../img/arrow.png" alt="Left Arrow">
        </div>
        <!-- 슬라이드1 -->
    	<div class="slide-content active">
        	<img src="../img/연어샐러드.jpg" alt="연어 샐러드 이미지" >
        	<h2>연어 샐러드</h2>
        	<p>부드러운 연어와 신선한 채소가 어우러진 고소한 연어 샐러드</p>
    	</div>
    	<!-- 슬라이드2 -->
    	<div class="slide-content">
        	<img src="../img/양배추롤.jpg" alt="양배추롤 이미지" >
        	<h2>양배추 롤</h2>
        	<p>아삭한 양배추에 다양한 속재료를 채운 깔끔하고 건강한 양배추롤</p>
    	</div>
    	<!-- 슬라이드3 -->
    	<div class="slide-content">
        	<img src="../img/전복죽.jpg" alt="전복죽 이미지" >
        	<h2>전복죽</h2>
        	<p>쫄깃한 전복과 영양 가득한 재료로 끓인 따뜻하고 부드러운 전복죽</p>
    	</div>
    	<!-- 슬라이드4 -->
    	<div class="slide-content">
        	<img src="../img/버터치킨카레.jpg" alt="버터치킨카레 이미지" >
        	<h2>버터치킨카레</h2>
        	<p>향신료와 버터의 풍미가 가득한 부드러운 치킨 카레</p>
    	</div>
    	<!-- 슬라이드5 -->
    	<div class="slide-content">
        	<img src="../img/가지탕수육.jpg" alt="가지탕수육 이미지" >
        	<h2>가지 탕수육</h2>
        	<p>부드러운 가지를 바삭하게 튀겨낸 뒤 새콤달콤한 소스를 곁들인 특별한 탕수육</p>
    	</div>
    	<!-- 슬라이드6 -->
    	<div class="slide-content">
        	<img src="../img/조개크림파스타.jpg" alt="조개크림파스타 이미지" >
        	<h2>조개 크림 파스타</h2>
        	<p>신선한 조개와 부드러운 크림 소스가 어우러진 고소하고 진한 맛의 파스타</p>
    	</div>

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
	<section class="main-content2">
    	<div class="content-wrapper">
        	<h2>두 번째 메인 콘텐츠 영역</h2>
        	<p>이곳은 다른 요소들로 구성된 메인 콘텐츠2 영역입니다.</p>
        <!-- 원하는 다른 요소를 여기에 추가하세요 -->
    	</div>
	</section>
	
	
	<%@ include file="../chatbot/chatbot.jsp" %>
	

</body>
<footer>
		<%@ include file="footer.jsp" %>
	</footer>
</html>