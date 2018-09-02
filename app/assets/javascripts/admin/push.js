$( document ).ready(function() {
  $('.webpush-button').on('click', (e) => {
    navigator.serviceWorker.ready
    .then((serviceWorkerRegistration) => {
      serviceWorkerRegistration.pushManager.getSubscription()
      .then((subscription) => {
        $.post('/admin/push', {
          subscription: subscription.toJSON(),
          message: 'You clicked a button!'
        });
      });
    });
  });
});
