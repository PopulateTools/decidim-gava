function hideUnwantedElements() {
  $("li:contains('Eliminar mi cuenta')").hide();
}

function openModal() {
  const modal = document.getElementById('uned-poll')
  modal.classList.remove('is-hidden')
}

function showNextProposalInModal(e) {
  e.preventDefault();

  var proposalTitle = $("#proposal-title").text()
  var proposalPosition = parseInt(proposalTitle.split(" ")[1]);

  openModal()
  $(`#uned-poll-button-top-4`).click()  // Click proposals tab
  $(`#uned-poll-buttons-slider-participa-${proposalPosition + 2}`).click()  // Display next proposal
  $(".uned-poll-content-footer")[0].scrollIntoView(); // Focus
}

document.addEventListener("DOMContentLoaded", function() {

  function toggleModal() {
    const modal = document.getElementById('uned-poll')
    modal.classList.toggle('is-hidden')
  }

  function closeModal() {
    const modal = document.getElementById('uned-poll')
    modal.classList.add('is-hidden')
  }

  const closeButton = document.getElementById('uned-poll-close-button');
  closeButton.addEventListener('click', () => {
    closeModal()
  })

  const toggleButtons = document.querySelectorAll(".uned-poll-toggle-button");
  toggleButtons.forEach(button => button.addEventListener('click', (e) => {
    e.preventDefault()
    toggleModal()
  }));

  const bottomButtons = document.querySelectorAll(".uned-poll-button-container")
  const topButtons = document.querySelectorAll(".uned-poll-buttons-top-slider")
  const participaButtons = document.querySelectorAll(".uned-poll-slider-participa-button-container")
  const ethicButton = document.getElementById('uned-poll-button-top-5')
  const cautelaButton = document.getElementById('uned-poll-button-top-4')

  ethicButton.addEventListener('click', () => {
    cautelaButton.dispatchEvent(new Event('click'));
  })

  topButtons.forEach(button => button.addEventListener('click', () => {
    buttonTop(event)
  }));

  bottomButtons.forEach(button => button.addEventListener('click', () => {
    buttonBottom(event)
  }));


  participaButtons.forEach(button => button.addEventListener('click', () => {
    buttonInside(event)
  }));

  let extractId = function(e) {
      const stringNumber = e.target.id;
      const reg = /\d+/;
      const idNumber = stringNumber.match(reg)[0]
      const idNumberPrev = Number(idNumber) - 1
      const idNumberNext = Number(idNumber) + 1
      return {
        idNumber,
        idNumberPrev,
        idNumberNext
      }
  };

  function showContainerText(id) {
    const containerText = document.getElementById(`uned-poll-slider-content-text-${id}`)
    document.querySelectorAll(".uned-poll-slider-content").forEach(container => container.classList.add('is-hidden'))
    containerText.classList.remove('is-hidden')
  }

  function buttonTop(e) {
    bottomButtons.forEach(container => container.classList.add('is-hidden'))
    bottomButtons.forEach(container => container.classList.remove('first-button', 'is-active-last', 'last-button'))

    topButtons.forEach(button => button.classList.remove('is-active-btn'))

    e.target.classList.add('is-active-btn');

    let {idNumber, idNumberPrev, idNumberNext} = extractId(e)

    const element = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumber}`)
    const elementNext = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberNext}`)
    const elementPrev = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberPrev}`)

    if(e.target.id === 'uned-poll-button-top-1') {

      element.classList.remove('is-hidden')
      elementNext.classList.remove('is-hidden')
      element.classList.add('first-button')

    } else if (e.target.id === 'uned-poll-button-top-4') {

      element.classList.remove('is-hidden')
      elementPrev.classList.remove('is-hidden')
      element.classList.add('last-button')
      elementPrev.classList.add('is-active-last')

    } else {

      elementPrev.classList.remove('is-hidden')
      elementNext.classList.remove('is-hidden')
      elementPrev.classList.add('is-active-last')
    }

    showContainerText(idNumber)
  }

  function buttonBottom(e) {

    e.target.classList.remove('is-disable');
    let {idNumber, idNumberPrev, idNumberNext} = extractId(e)

    const buttonBottomActive = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumber}`)
    const buttonBottomActiveNext = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberNext}`)
    const buttonBottomActivePrev = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberPrev}`)

    topButtons.forEach(button => button.classList.remove('is-active-btn'))
    const buttonTop = document.getElementById(`uned-poll-button-top-${idNumber}`)
    buttonTop.classList.add('is-active-btn')

    bottomButtons.forEach(container => container.classList.add('is-hidden'))
    bottomButtons.forEach(container => container.classList.remove('first-button', 'last-button'))

    if(e.target.classList.contains('is-active-last') && e.target.id !== 'uned-poll-buttons-bottom-slider-1') {

      bottomButtons.forEach(button => button.classList.remove('is-active-last'))
      buttonBottomActivePrev.classList.remove('is-hidden', 'is-active-last')
      buttonBottomActiveNext.classList.remove('is-hidden')
      buttonBottomActivePrev.classList.add('is-active-last')

    } else if(e.target.id === 'uned-poll-buttons-bottom-slider-1') {

      buttonBottomActive.classList.remove('is-hidden')
      buttonBottomActive.classList.add('first-button')
      buttonBottomActiveNext.classList.remove('is-hidden')

    } else if(e.target.id === 'uned-poll-buttons-bottom-slider-4') {

      buttonBottomActive.classList.remove('is-hidden')
      buttonBottomActivePrev.classList.remove('is-hidden')
      buttonBottomActivePrev.classList.add('is-active-last')
      buttonBottomActive.classList.add('last-button')

    } else {
      bottomButtons.forEach(button => button.classList.remove('is-active-last'))

      buttonBottomActivePrev.classList.remove('is-hidden')
      buttonBottomActivePrev.classList.add('is-active-last')
      buttonBottomActiveNext.classList.remove('is-hidden')
    }

    showContainerText(idNumber)
  }

  function buttonInside(e) {

    e.target.classList.remove('is-hidden');
    let {idNumber, idNumberPrev, idNumberNext} = extractId(e)

    const buttonBottomActive = document.getElementById(`uned-poll-buttons-slider-participa-${idNumber}`)
    const buttonBottomActiveNext = document.getElementById(`uned-poll-buttons-slider-participa-${idNumberNext}`)
    const buttonBottomActivePrev = document.getElementById(`uned-poll-buttons-slider-participa-${idNumberPrev}`)

    const containerText = document.getElementById(`uned-poll-participa-content-${idNumber}`)
    const allContainerText = document.querySelectorAll(".uned-poll-slider-participa-content")

    allContainerText.forEach(container => container.classList.add('is-hidden'))
    containerText.classList.remove('is-hidden')

    participaButtons.forEach(container => container.classList.add('is-hidden'))

    const participaLastElement = participaButtons.length
    const participaFirstElement = 1

    if(e.target.classList.contains('is-active-last') && e.target.id !== `uned-poll-buttons-slider-participa-${participaFirstElement}`) {
      participaButtons.forEach(button => button.classList.remove('is-active-last', 'last-button'))
      buttonBottomActivePrev.classList.remove('is-hidden')
      buttonBottomActiveNext.classList.remove('is-hidden')
      buttonBottomActivePrev.classList.add('is-active-last')

    } else if(e.target.id === `uned-poll-buttons-slider-participa-${participaFirstElement}`) {
      participaButtons.forEach(button => button.classList.remove('last-button'))
      buttonBottomActive.classList.remove('is-hidden')
      buttonBottomActiveNext.classList.remove('is-hidden')
      buttonBottomActive.classList.add('first-button')

    } else if(e.target.id === `uned-poll-buttons-slider-participa-${participaLastElement}`) {
      participaButtons.forEach(button => button.classList.remove('first-button'))
      buttonBottomActivePrev.classList.remove('is-hidden')
      buttonBottomActive.classList.remove('is-hidden')
      buttonBottomActive.classList.add('last-button')
      buttonBottomActivePrev.classList.add('is-active-last')
      const containerInsideButtons = document.getElementById('uned-poll-container-participa-buttons')
      containerInsideButtons.classList.add('is-hidden')

    } else {
      participaButtons.forEach(button => button.classList.remove('is-active-last', 'last-button', 'first-button'))
      buttonBottomActivePrev.classList.remove('is-hidden')
      buttonBottomActivePrev.classList.add('is-active-last')
      buttonBottomActiveNext.classList.remove('is-hidden')
    }
  }

  bottomButtons.forEach(button => button.addEventListener('click', (e) => {
    scrollToTopSection()
  }));

  topButtons.forEach(button => button.addEventListener('click', (e) => {
    scrollToTopSection()
  }));

  function scrollToTopSection() {
    document.getElementById("uned-poll-button-top-1").scrollIntoView();
  }

  const toggleParent = '.uned-poll-accordion-parent'
  const toggleChild = '.uned-poll-accordion-child'

  function toggleQuestions(elementClick) {
    const toggleQuestionsButton = document.querySelectorAll(elementClick);

    for (var i = 0, l = toggleQuestionsButton.length; i < l; i++) {
      toggleQuestionsButton[i].onclick = function() {
        for (var j = 0; j < l; j++) {
          if (toggleQuestionsButton[j] != this) {
            toggleQuestionsButton[j].nextElementSibling.classList.remove('is-visible')
            toggleQuestionsButton[j].classList.remove('is-open')
          }
        }
        const element = this;
        const elementToggle = element.nextElementSibling
        element.classList.toggle('is-open')
        elementToggle.classList.toggle('is-visible')
      }
    }
  }

  toggleQuestions(toggleParent);
  toggleQuestions(toggleChild);
  hideUnwantedElements();

  $("#show-next-proposal").click(showNextProposalInModal);

  let url = window.location.href
  if(url.includes('marco-etico')) {
    cautelaButton.dispatchEvent(new Event('click'));
  }
});
