<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/main.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<script>
	document.addEventListener('DOMContentLoaded', () => {
	    let currentSlide = 0;
	    const slides = document.querySelectorAll('.slide-content');
	    const totalSlides = slides.length;
	    const banner = document.querySelector('.banner');
	    const pauseButton = document.querySelector('#play-pause-button');
	    const pauseIcon = pauseButton.querySelector('i');
	
	    let isPaused = false;
	    let slideInterval;
	
	    // 배너의 초기 배경색을 투명으로 설정
	    banner.style.backgroundColor = 'transparent';
	
	    // 배너에 마우스를 올렸을 때
	    banner.addEventListener('mouseenter', () => {
	        banner.style.backgroundColor = 'white';
	    });
	
	    // 배너에서 마우스를 내렸을 때
	    banner.addEventListener('mouseleave', () => {
	        if (window.scrollY > 50) {
	            banner.style.backgroundColor = 'white';
	        } else {
	            banner.style.backgroundColor = 'transparent';
	        }
	    });
	
	    // 스크롤 시 배너 이벤트
	    window.addEventListener('scroll', () => {
	        if (window.scrollY > 50) {
	            banner.style.backgroundColor = 'white';
	            banner.style.transition = 'background-color 0.3s ease';
	        } else {
	            banner.style.backgroundColor = 'transparent';
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
	
	        document.querySelector('.current-slide').textContent = index + 1;
	        document.querySelector('.total-slides').textContent = totalSlides;
	    }
	
	    function nextSlide() {
	        currentSlide = (currentSlide + 1) % totalSlides;
	        showSlide(currentSlide);
	    }
	
	    function prevSlide() {
	        currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
	        showSlide(currentSlide);
	    }
	
	    function startAutoSlide() {
	        stopAutoSlide(); // 기존 타이머를 초기화
	        slideInterval = setInterval(nextSlide, 5000); // 5초마다 슬라이드 전환
	        isPaused = false;
	        updatePauseButton();
	    }
	
	    function stopAutoSlide() {
	        clearInterval(slideInterval);
	        isPaused = true;
	        updatePauseButton();
	    }
	
	    function toggleAutoSlide() {
	        if (isPaused) {
	            startAutoSlide();
	        } else {
	            stopAutoSlide();
	        }
	    }
	
	    function updatePauseButton() {
	        if (isPaused) {
	            pauseIcon.classList.remove('fa-pause');
	            pauseIcon.classList.add('fa-play');
	        } else {
	            pauseIcon.classList.remove('fa-play');
	            pauseIcon.classList.add('fa-pause');
	        }
	    }
	
	    // 이벤트 리스너 추가
	    document.querySelector('.left-arrow').addEventListener('click', () => {
	        prevSlide();
	        startAutoSlide(); // 슬라이드를 수동으로 변경했을 때 타이머를 초기화
	    });
	    document.querySelector('.right-arrow').addEventListener('click', () => {
	        nextSlide();
	        startAutoSlide(); // 슬라이드를 수동으로 변경했을 때 타이머를 초기화
	    });
	    pauseButton.addEventListener('click', toggleAutoSlide);
	
	    // 처음에 첫 슬라이드와 슬라이드 번호 표시
	    showSlide(currentSlide);
	    startAutoSlide(); // 자동 슬라이드 시작
	});

</script>
<%@ include file="header.jsp" %>
</head>
<body class="main-body">
    <!-- 메인 콘텐츠 섹션 -->
    <section class="main-content">
        <div class="arrow left-arrow">
    		<i class="fas fa-chevron-left"></i>
		</div>
        <!-- 슬라이드1 -->
    	<div class="slide-content active">
        	<a href="../recipe/recipeDetail.jsp?id=634&title=연어 샐러드">
            	<img src="../img/연어샐러드.jpg" alt="연어 샐러드 이미지">
        	</a>
        	<h2>연어 샐러드</h2>
        	<p>부드러운 연어와 신선한 채소가 어우러진<br>
        	고소한 연어 샐러드</p>
    	</div>
    	<!-- 슬라이드2 -->
    	<div class="slide-content">
        	<a href="../recipe/recipeDetail.jsp?id=137&title=된장%20두부찌개">
            	<img src="../img/된장두부찌개.jpg" alt="된장두부찌개 이미지">
        	</a>
        	<h2>된장 두부찌개</h2>
        	<p>깊고 구수한 된장 국물에<br>
        	부드러운 두부와 신선한 채소가 어우러진 한국의 전통 찌개</p>
    	</div>
    	<!-- 슬라이드3 -->
    	<div class="slide-content">
        	<a href="../recipe/recipeDetail.jsp?id=333&title=바다향이%20풍부한%20전복죽">
            	<img src="../img/전복죽.jpg" alt="전복죽 이미지">
        	</a>
        	<h2>전복죽</h2>
        	<p>쫄깃한 전복과 영양 가득한 재료로 끓인<br>
        	따뜻하고 부드러운 전복죽</p>
    	</div>
    	<!-- 슬라이드4 -->
    	<div class="slide-content">
        	<a href="../recipe/recipeDetail.jsp?id=3270&title=버터치킨카레">
            	<img src="../img/버터치킨카레.png" alt="버터치킨카레 이미지">
        	</a>
        	<h2>버터치킨카레</h2>
        	<p>향신료와 버터의 풍미가 가득한 부드러운 치킨 카레</p>
    	</div>
    	<!-- 슬라이드5 -->
    	<div class="slide-content">
        	<a href="../recipe/recipeDetail.jsp?id=3246&title=가지%20탕수육">
            	<img src="../img/가지탕수육.jpg" alt="가지탕수육 이미지">
        	</a>
        	<h2>가지 탕수육</h2>
        	<p>부드러운 가지를 바삭하게 튀겨낸 뒤<br>
        	새콤달콤한 소스를 곁들인 특별한 탕수육</p>
    	</div>
    	<!-- 슬라이드6 -->
    	<div class="slide-content">
        	<a href="../recipe/recipeDetail.jsp?id=450&title=조개크림파스타">
            	<img src="../img/조개크림파스타.jpg" alt="조개크림파스타 이미지">
        	</a>
        	<h2>조개 크림 파스타</h2>
        	<p>신선한 조개와 부드러운 크림 소스가 어우러진<br>
        	고소하고 진한 맛의 파스타</p>
    	</div>
		<!-- 슬라이드7 -->
    	<div class="slide-content">
        	<a href="../recipe/recipeDetail.jsp?id=298&title=양배추롤">
            	<img src="../img/양배추롤.jpg" alt="양배추롤 이미지">
        	</a>
        	<h2>양배추 롤</h2>
        	<p>아삭한 양배추에 다양한 속재료를 채운<br>
        	깔끔하고 건강한 양배추롤</p>
    	</div>
    	<!-- 슬라이드8 -->
    	<div class="slide-content">
        	<a href="../recipe/recipeDetail.jsp?id=513&title=오징어순대">
            	<img src="../img/오징어순대.jpg" alt="오징어순대 이미지">
        	</a>
        	<h2>오징어순대</h2>
        	<p>쫄깃한 오징어 속에 다채로운 재료를 가득 채워 만든 특별한 순대</p>
    	</div>
        <div class="arrow right-arrow">
    		<i class="fas fa-chevron-right"></i>
		</div>
        <!-- 슬라이드 네비게이션 -->
    	<div class="slider-nav">
        	<span class="current-slide">1</span>
        	<div class="line"></div>
        	<span class="total-slides">8</span>&nbsp;
        	<button id="play-pause-button">
    			<i class="fas fa-pause"></i> <!-- 일시정지 아이콘 -->
			</button>
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