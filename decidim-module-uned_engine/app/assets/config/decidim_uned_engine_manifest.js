function hideUnwantedElements() {
  $("li:contains('Eliminar mi cuenta')").hide();
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

  function scrollToTopSection() {
    document.getElementById("uned-poll-button-top-1").scrollIntoView();
  }

  function toggleQuestions() {
    const toggleQuestionsButton = document.querySelectorAll(".uned-poll-slider-content-accordion-title");

    for (var i = 0, l = toggleQuestionsButton.length; i < l; i++) {
      toggleQuestionsButton[i].onclick = function() {
        for (var j = 0; j < l; j++) {
          if (toggleQuestionsButton[j] != this) {
            toggleQuestionsButton[j].nextElementSibling.classList.remove('is-visible')
          }
        }
        const element = this;
        const elementToggle = element.nextElementSibling
        elementToggle.classList.toggle('is-visible')
      }
    }
  }

  toggleQuestions();
  hideUnwantedElements();
});
