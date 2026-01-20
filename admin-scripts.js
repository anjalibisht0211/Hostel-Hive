/* Shared JS: charts and small interactions */

/* Complaints charts demo using Chart.js */
function renderComplaintsCharts() {
  // pie 1: pending vs resolved
  const ctx1 = document.getElementById('complaintStatusChart');
  if (ctx1) {
    new Chart(ctx1, {
      type: 'doughnut',
      data: {
        labels: ['Pending','Resolved'],
        datasets: [{
          data: [28, 8],
          backgroundColor: ['#ff6b6b','#2ecc71']
        }]
      },
      options: { maintainAspectRatio:false, cutout:'60%' }
    });
  }

  // pie 2: categories
  const ctx2 = document.getElementById('complaintCategoryChart');
  if (ctx2) {
    new Chart(ctx2, {
      type: 'pie',
      data: {
        labels: ['Electricity','Plumbing','Food','Cleaning','Other'],
        datasets: [{
          data: [20,8,6,10,12],
          backgroundColor: ['#ff6b6b','#ffd369','#6b5bff','#9b59b6','#3fb0ff']
        }]
      },
      options: { maintainAspectRatio:false }
    });
  }
}

/* Mark a complaint resolved (demo) */
function markResolved(btn){
  const tr = btn.closest('tr');
  if(!tr) return;
  const statusCell = tr.querySelector('.status-cell');
  statusCell.innerText = 'Resolved';
  statusCell.className = 'status-cell status-resolved';
  btn.disabled = true;
  btn.innerText = 'Resolved';
  btn.className = 'btn ghost';
}

/* Room booking toggle */
function toggleBooking(el){
  const text = document.getElementById('roomBookingStatusText');
  if(el.checked){
    text.innerText = 'Enabled';
    text.style.color = '#2ecc71';
  } else {
    text.innerText = 'Disabled';
    text.style.color = '#e74c3c';
  }
}

/* highlight nav active */
function markActiveLink(){
  const links = document.querySelectorAll('.nav a');
  links.forEach(a=>{
    if(window.location.pathname.endsWith(a.getAttribute('data-file'))){
      a.classList.add('active');
    }
  });
}

/* init on DOM ready */
document.addEventListener('DOMContentLoaded', function(){
  if(typeof Chart !== 'undefined') renderComplaintsCharts();
  markActiveLink();
});
