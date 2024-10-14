<%@ page import="java.util.List" %>
<%@ page import="exercise.ExerciseRoutineMgr"%>
<%@ page import="exercise.ExerciseRoutineBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    ExerciseRoutineMgr routineMgr = new ExerciseRoutineMgr();
    List<ExerciseRoutineBean> routineList = routineMgr.noPart();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/main.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<script>
	document.addEventListener('DOMContentLoaded', () => {
		// 슬라이드 관련 코드
	    let currentSlide = 0;
	    const slides = document.querySelectorAll('.slide-content');
	    const totalSlides = slides.length;
	    const banner = document.querySelector('.banner');
	    const pauseButton = document.querySelector('#play-pause-button');
	    const pauseIcon = pauseButton.querySelector('i');
	    const progressBar = document.querySelector('.progress-bar');
	
	    let isPaused = false;
	    let slideInterval;
	
	    banner.style.backgroundColor = 'transparent';
	
	    banner.addEventListener('mouseenter', () => {
	        banner.style.backgroundColor = 'white';
	    });
	
	    banner.addEventListener('mouseleave', () => {
	        if (window.scrollY > 50) {
	            banner.style.backgroundColor = 'white';
	        } else {
	            banner.style.backgroundColor = 'transparent';
	        }
	    });
	
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
	        resetProgressBar();
	    }
	
	    function nextSlide() {
	        currentSlide = (currentSlide + 1) % totalSlides;
	        showSlide(currentSlide);
	    }
	
	    function startAutoSlide() {
	        stopAutoSlide();
	        slideInterval = setInterval(nextSlide, 5000);
	        isPaused = false;
	        updatePauseButton();
	        resetProgressBar();
	    }
	
	    function stopAutoSlide() {
	        clearInterval(slideInterval);
	        isPaused = true;
	        updatePauseButton();
	        progressBar.style.width = '0%';
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
	
	    function resetProgressBar() {
	        progressBar.style.transition = 'none';
	        progressBar.style.width = '0%';
	        setTimeout(() => {
	            progressBar.style.transition = 'width 5s linear';
	            progressBar.style.width = '100%';
	        }, 10);
	    }
	
	    document.querySelector('.left-arrow').addEventListener('click', () => {
	        prevSlide();
	        startAutoSlide();
	    });
	    document.querySelector('.right-arrow').addEventListener('click', () => {
	        nextSlide();
	        startAutoSlide();
	    });
	    pauseButton.addEventListener('click', toggleAutoSlide);
	
	    showSlide(currentSlide);
	    startAutoSlide();
	    
	 	// 메인2와 메인3 애니메이션 통합 코드
	 	const elementsToObserve = [
	        document.querySelector('.content-wrapper h2'),  // 메인2 h2
	        ...document.querySelectorAll('.promo-card'),    // 메인2 프로모카드들
	        document.querySelector('.content-wrapper3 h2'), // 메인3 h2
	        document.querySelector('.main3-p')              // 메인3 p
	    ];
	    
	    const options = {
	        threshold: 0.1 // 10%가 보일 때 애니메이션 실행
	    };
	
	    const observer = new IntersectionObserver(function (entries) {
	        entries.forEach((entry) => {
	            if (entry.isIntersecting) {
	                entry.target.classList.add('show');
	            } else {
	                entry.target.classList.remove('show');
	            }
	        });
	    }, options);

	    // 메인2 h2, 프로모카드, 메인3 h2, p 모두 관찰
	    elementsToObserve.forEach(element => {
	        if (element) observer.observe(element);
	    });


	    // 메인3 슬라이드 애니메이션 코드
	    const exerciseSlides = document.querySelectorAll('.exercise-slide');
	    const slideWrapper = document.querySelector('.exercise-slides');
	    const slideCount = exerciseSlides.length;
	    const slidesPerView = 4;
	    let currentSlideIndex = 0;

	    function shuffleSlides() {
	        let shuffled = Array.from(exerciseSlides);
	        shuffled.sort(() => Math.random() - 0.5);
	        return shuffled;
	    }

	    function showSlides(index) {
	        slideWrapper.innerHTML = '';
	        const shuffledSlides = shuffleSlides();
	        const end = Math.min(index + slidesPerView, slideCount);
	        for (let i = index; i < end; i++) {
	            slideWrapper.appendChild(shuffledSlides[i]);
	        }
	    }

	    function autoSlide() {
	        currentSlideIndex = (currentSlideIndex + slidesPerView) % slideCount;
	        showSlides(currentSlideIndex);
	    }

	    setInterval(autoSlide, 4000);

	    showSlides(currentSlideIndex);
	
	});

</script>
<%@ include file="header.jsp" %>
</head>
<body class="main-body">
    <!-- 메인 콘텐츠1 -->
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
		    <div class="line">
		        <div class="progress-bar"></div>
		    </div>
		    <span class="total-slides">8</span>&nbsp;
		    <button id="play-pause-button">
		        <i class="fas fa-pause"></i>
		    </button>
		</div>

	</section>
	<!-- 메인 콘텐츠2 -->
	<section class="main-content2">
	    <div class="content-wrapper">
	    <h2>Fit Time과 함께 식단 관리해요 :-)</h2>
	        <div class="intro-section">
	            <!-- 식단 기록 소개 -->
	            <div class="promo-card">
	                <div class="promo-icon">
	                    <i class="fas fa-utensils"></i> <!-- 식단 기록 아이콘 -->
	                </div>
	                <div class="promo-content">
	                    <h3>오늘의 식단 기록</h3>
	                    <p>매일 먹은 음식을 간편하게 기록하고 나만의 식단을 관리해보세요.</p>
	                    <a href="../diet/DietRecord.jsp" class="promo-button">식단 기록하기</a>
	                </div>
	            </div>
	            
	            <!-- 하루 권장 칼로리 계산 소개 -->
	            <div class="promo-card">
	                <div class="promo-icon">
	                    <i class="fas fa-calculator"></i> <!-- 칼로리 계산 아이콘 -->
	                </div>
	                <div class="promo-content">
	                    <h3>하루 권장 칼로리 계산</h3>
	                    <p>나의 신체 조건에 맞는 권장 칼로리를 알아보고 목표를 이루어 보세요.</p>
	                    <a href="../diet/CalorieCalc.jsp" class="promo-button">칼로리 계산하기</a>
	                </div>
	            </div>
	        </div>
	    </div>
	</section>
	<!-- 메인 콘텐츠3 -->
	<section class="main-content3">
	    <div class="content-wrapper3">
	        <h2>오늘, 운동 뭐하지?</h2>
	        <p class="main3-p">Fit Time과 함께 나에게 딱 맞는 운동 루틴을 추천받아보세요!</p>
	        <div class="exercise-slides">
	            <% for (ExerciseRoutineBean routine : routineList) { %>
	                <div class="exercise-slide">
	                    <a href="<%= routine.getExerciseLink() %>" target="_blank">
	                        <img src="https://img.youtube.com/vi/<%= routine.getExerciseLink().substring(routine.getExerciseLink().indexOf("v=") + 2) %>/0.jpg" alt="<%= routine.geteName() %>">
	                        <div class="exercise-info">
	                            <h3><%= routine.geteName() %></h3>
	                            <p><%= routine.getExercise() %></p>
	                        </div>
	                    </a>
	                </div>
	            <% } %>
	        </div>
	    </div>
	</section>
	<%@ include file="../chatbot/chatbot.jsp" %>
</body>
<footer>
	<%@ include file="footer.jsp" %>
</footer>
</html>