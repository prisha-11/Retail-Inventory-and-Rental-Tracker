// Using Chart.js to add simple visuals
const ctx1 = document.getElementById('totalSalesChart').getContext('2d');
const ctx2 = document.getElementById('retailChart').getContext('2d');
const ctx3 = document.getElementById('rentalChart').getContext('2d');

new Chart(ctx1, {
  type: 'doughnut',
  data: {
    labels: ['Retail', 'Rental'],
    datasets: [{
      data: [18200, 7200],
      backgroundColor: ['#D3E671', '#FF8989']  // using palette colors
    }]
  },
  options: {
    plugins: { legend: { display: false } }
  }
});

new Chart(ctx2, {
  type: 'line',
  data: {
    labels: ['Mon','Tue','Wed','Thu','Fri'],
    datasets: [{
      data: [3000,4000,3200,4500,3500],
      borderColor: '#89AC46',
      fill: false
    }]
  }
});

new Chart(ctx3, {
  type: 'line',
  data: {
    labels: ['Mon','Tue','Wed','Thu','Fri'],
    datasets: [{
      data: [1200,900,1600,1500,2000],
      borderColor: '#FF8989',
      fill: false
    }]
  }
});
