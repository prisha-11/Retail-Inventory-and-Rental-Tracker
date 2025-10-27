// Using Chart.js to add simple visuals
const ctx1 = document.getElementById('totalSalesChart');
const ctx2 = document.getElementById('retailChart');
const ctx3 = document.getElementById('rentalChart');

new Chart(ctx1, {
  type: 'doughnut',
  data: {
    labels: ['Retail', 'Rental'],
    datasets: [{
      data: [18200, 7200],
      backgroundColor: ['#3b82f6', '#60a5fa']
    }]
  },
  options: { plugins: { legend: { display: false } } }
});

new Chart(ctx2, {
  type: 'line',
  data: {
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
    datasets: [{
      data: [3000, 4000, 3200, 4500, 3500],
      borderColor: '#3b82f6',
      fill: false
    }]
  }
});

new Chart(ctx3, {
  type: 'line',
  data: {
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
    datasets: [{
      data: [1200, 900, 1600, 1500, 2000],
      borderColor: '#60a5fa',
      fill: false
    }]
  }
});
