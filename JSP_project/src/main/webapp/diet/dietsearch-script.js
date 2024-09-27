// API 키 설정
const API_KEY = 'fb0c3f7a6ebe4a419413';

// 식품 검색 함수
function searchFood() {
    console.log('searchFood 함수 실행');
    const searchInput = document.getElementById('foodSearchInput');
    const searchTerm = searchInput.value.trim();

    if (searchTerm === '') {
        alert('검색어를 입력해주세요.');
        return;
    }

    const url = `https://openapi.foodsafetykorea.go.kr/api/${API_KEY}/I2790/json/1/25/DESC_KOR=${encodeURIComponent(searchTerm)}`;
    console.log('요청 URL:', url);

    fetch(url)
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers);
            return response.json();
        })
        .then(data => {
            console.log('API Response:', data);
            if (data.I2790 && Array.isArray(data.I2790.row)) {
                displayResults(data.I2790.row);
            } else {
                console.error('Unexpected API response structure:', data);
                alert('해당 키워드를 포함하고 있는 식품이 없습니다.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('데이터를 불러오는 중 오류가 발생했습니다.');
        });
}

// 검색 결과 표시 함수
function displayResults(items) {
    console.log('displayResults 함수 실행', items);
    const resultsDiv = document.getElementById('searchResults');
    resultsDiv.innerHTML = '';

    if (items.length === 0) {
        resultsDiv.innerHTML = '<p>검색 결과가 없습니다.</p>';
        return;
    }

    const table = document.createElement('table');

    // 테이블 헤더 생성
    const headerRow = table.insertRow();
    const headers = ['식품명', '열량(kcal)', '탄수화물(g)', '단백질(g)', '지방(g)', '당류(g)'];
    headers.forEach(header => {
        const th = document.createElement('th');
        th.textContent = header;
        headerRow.appendChild(th);
    });

    // 데이터 행 생성
    items.forEach(item => {
        const row = table.insertRow();
        [
            item.DESC_KOR,
            item.NUTR_CONT1,
            item.NUTR_CONT2,
            item.NUTR_CONT3,
            item.NUTR_CONT4,
            item.NUTR_CONT5
        ].forEach(value => {
            const cell = row.insertCell();
            cell.textContent = value || '-';
        });
    });

    resultsDiv.appendChild(table);
}

// 이벤트 리스너 등록
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM 로드 완료');
    const searchButton = document.getElementById('searchButton');
    if (searchButton) {
        console.log('검색 버튼 찾음');
        searchButton.addEventListener('click', searchFood);
    } else {
        console.error('Search button not found');
    }

    const searchInput = document.getElementById('foodSearchInput');
    if (searchInput) {
        console.log('검색 입력 필드 찾음');
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                searchFood();
            }
        });
    } else {
        console.error('Search input not found');
    }
});