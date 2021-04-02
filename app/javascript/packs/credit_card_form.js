function getURLParameter(parameterName) {
  var result = null, tmp = [];
  location.search
    .substr(1)
    .split("&")
    .forEach(item => {
      tmp = item.split("=");
      if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
    });
  return result;
}

$(() => {
  $("#tenant_plan").trigger("change")
  let showError, stripeResponseHandler, submitHandler, handlePlanChange
  // Function to get params from url
  

  // Form submission handler 
  submitHandler = (e) => {
    let $form = $(e.currentTarget)
    $form.find("input[type=submit]").prop("disabled", true)
    if (Stripe) {
      Stripe.card.createToken($form, stripeResponseHandler)
    } else {
      showError("Failed to load credit card processing functionnality, please reload the page.")
    }
    return false
  }
  
  // Form submission event listener
  $(".cc-form").on("submit", submitHandler)

  // Plan dropdown event listener
  $("#tenant_plan").on("change", (e) => { handlePlanChange($("#tenant_plan :selected").val(), ".cc-form") })

  // Plan dropdown handler
  handlePlanChange = (plan_type, form) => {
    let $form = $(form)
    if (plan_type == undefined) {
      plan_type = $('#tenant_plan :selected').val()
    }
    if (plan_type == 'premium') {
      $('[data-stripe]').prop('required', true)
      $form.off('submit')
      $form.on('submit', submitHandler)
      $("[data-stripe]").show()
    } else {
      $("[data-stripe]").hide()
      $form.off('submit')
      $('[data-stripe]').removeProp('required')
    }
  } 

  // call plan handler on page load
  handlePlanChange(getURLParameter('plan'), ".cc-form")

  // token and credit card handler function
  stripeResponseHandler = (status, response) => {
    let token, $form;
    $form = $(".cc-form")

    if (response.error) {
      console.log(response.error.message)
      showError(response.error.message)
      $form.find("input[type=submit]").prop("disabled", false)
    } else {
      token = response.id
      $form.append($("<input type='hidden' name='payment[token]' />").val(token))
      $("[data-stripe=number]").remove()
      $("[data-stripe=cvv]").remove()
      $("[data-stripe=exp-year]").remove()
      $("[data-stripe=exp-month]").remove()
      $("[data-stripe=label]").remove()
      $form.get(0).submit()

    }
    return false;
  }

  // Function to show stripe errors
  showError = (message) => {
    if ($("#flash-messages").size() < 1) 
      $(".container.main div:first").prepend("<div id='flash-messages' ></div>")
    $("flash-messages").html('<div class="alert alert-warning"><a class="close", data-dismiss="alert">x</a> <div id "flash_alert">' + message + '</div> </div>')
    $(".alert").delay(5000).fadeOut(3000)
    return false
  }
})