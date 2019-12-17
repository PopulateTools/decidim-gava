document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll(".uned-poll-buttons-top-slider").forEach(button => button.addEventListener('click', () => {
    buttonTop(event)
  }));
  function buttonTop(e) {
    document.querySelectorAll(".uned-poll-buttons-top-slider").forEach(button => button.classList.remove('is-active-btn'))

    e.target.classList.add('is-active-btn');
    const stringNumber = e.target.id;
    const reg = /\d+/;
    const idNumber = stringNumber.match(reg)
    const idNumberSibling = Number(idNumber) - 1
    const idNumberSiblingNext = Number(idNumber) + 1

    document.querySelectorAll(".uned-poll-button-container").forEach(container => container.classList.add('is-disable'))
    document.querySelectorAll(".uned-poll-button-container").forEach(container => container.classList.remove('is-active', 'first-button', 'is-active-last', 'last-button'))

    if(e.target.id === 'uned-poll-button-top-1') {

      const element = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumber[0]}`)
      const elementNext = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberSiblingNext}`)

      element.classList.remove('is-disable')
      elementNext.classList.remove('is-disable')
      element.classList.add('is-active')
      elementNext.classList.add('is-active')

      const buttonBottom = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumber}`)
      const buttonBottomSibling = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberSiblingNext}`)

      buttonBottom.classList.add('first-button')
      buttonBottomSibling.classList.add('first-button')

    } else if (e.target.id === 'uned-poll-button-top-5') {
      const element = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumber[0]}`)
      const elementPrev = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberSibling}`)

      element.classList.remove('is-disable')
      elementPrev.classList.remove('is-disable')
      element.classList.add('is-active')
      elementPrev.classList.add('is-active', 'is-active-last')

      const buttonBottom = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumber}`)
      buttonBottom.classList.add('last-button')
    } else {
      const buttonBottom = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberSibling}`)
      const buttonBottomSibling = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberSiblingNext}`)
      buttonBottom.classList.remove('is-disable', 'is-active-last')
      buttonBottomSibling.classList.remove('is-disable')
      buttonBottom.classList.add('is-active', 'is-active-last')
      buttonBottomSibling.classList.add('is-active')

    }

    const containerText = document.getElementById(`uned-poll-slider-content-text-${idNumber[0]}`)
    document.querySelectorAll(".uned-poll-slider-content").forEach(container => container.classList.add('is-disable'))
    document.querySelectorAll(".uned-poll-slider-content").forEach(container => container.classList.remove('is-active'))
    containerText.classList.remove('is-disable')
    containerText.classList.add('is-active')

  }

  document.querySelectorAll(".uned-poll-button-container").forEach(button => button.addEventListener('click', () => {
    buttonBottom(event)
  }));


  function buttonBottom(e) {
    document.querySelectorAll(".uned-poll-button-container").forEach(button => button.classList.remove('is-active'))

    e.target.classList.add('is-active');
    const stringNumber = e.target.id;
    const reg = /\d+/;
    const idNumber = stringNumber.match(reg)
    const idNumberSiblingNext = Number(idNumber) + 1
    const idNumberSiblingPrev = Number(idNumber) - 1

    const buttonBottomActive = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumber[0]}`)
    const buttonBottomActiveNext = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberSiblingNext}`)
    const buttonBottomActivePrev = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberSiblingPrev}`)

    document.querySelectorAll(".uned-poll-buttons-top-slider").forEach(button => button.classList.remove('is-active-btn'))
    const buttonTop = document.getElementById(`uned-poll-button-top-${idNumber[0]}`)
    buttonTop.classList.add('is-active-btn')

    const containerText = document.getElementById(`uned-poll-slider-content-text-${idNumber[0]}`)
    document.querySelectorAll(".uned-poll-slider-content").forEach(container => container.classList.add('is-disable'))
    document.querySelectorAll(".uned-poll-slider-content").forEach(container => container.classList.remove('is-active'))
    containerText.classList.remove('is-disable')
    containerText.classList.add('is-active')

    document.querySelectorAll(".uned-poll-button-container").forEach(container => container.classList.add('is-disable'))
    document.querySelectorAll(".uned-poll-button-container").forEach(container => container.classList.remove('is-active', 'first-button', 'last-button'))

    if(e.target.classList.contains('is-active-last') && e.target.id !== 'uned-poll-buttons-bottom-slider-1') {

      document.querySelectorAll(".uned-poll-button-container").forEach(button => button.classList.remove('is-active-last'))
      buttonBottomActivePrev.classList.remove('is-disable', 'is-active-last')
      buttonBottomActiveNext.classList.remove('is-disable')
      buttonBottomActivePrev.classList.add('is-active', 'is-active-last')
      buttonBottomActiveNext.classList.add('is-active')

    } else if(e.target.id === 'uned-poll-buttons-bottom-slider-1') {

      buttonBottomActive.classList.remove('is-disable')
      buttonBottomActiveNext.classList.remove('is-disable')
      buttonBottomActive.classList.add('is-active')
      buttonBottomActiveNext.classList.add('is-active')
      const buttonBottom = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumber}`)
      const buttonBottomSibling = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberSiblingNext}`)

      buttonBottom.classList.add('first-button')

    } else if(e.target.id === 'uned-poll-buttons-bottom-slider-5') {

      buttonBottomActive.classList.remove('is-disable')
      buttonBottomActivePrev.classList.remove('is-disable')
      buttonBottomActive.classList.add('is-active')
      buttonBottomActivePrev.classList.add('is-active', 'is-active-last')

      const buttonBottom = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumber}`)
      buttonBottom.classList.add('last-button')
    } else {
      document.querySelectorAll(".uned-poll-button-container").forEach(button => button.classList.remove('is-active-last'))
      buttonBottomActivePrev.classList.remove('is-disable')
      buttonBottomActivePrev.classList.add('is-active', 'is-active-last')
      buttonBottomActiveNext.classList.remove('is-disable')
      buttonBottomActiveNext.classList.add('is-active')
    }
  }

  document.querySelectorAll(".uned-poll-slider-participa-button-container").forEach(button => button.addEventListener('click', () => {
    buttonInside(event)
  }));

  function buttonInside(e) {
    document.querySelectorAll(".uned-poll-slider-participa-button-container").forEach(button => button.classList.remove('is-active'))

    e.target.classList.add('is-active');
    const stringNumber = e.target.id;
    const reg = /\d+/;
    const idNumber = stringNumber.match(reg)
    const idNumberSiblingNext = Number(idNumber) + 1
    const idNumberSiblingPrev = Number(idNumber) - 1

    const buttonBottomActive = document.getElementById(`uned-poll-buttons-slider-participa-${idNumber[0]}`)
    const buttonBottomActiveNext = document.getElementById(`uned-poll-buttons-slider-participa-${idNumberSiblingNext}`)
    const buttonBottomActivePrev = document.getElementById(`uned-poll-buttons-slider-participa-${idNumberSiblingPrev}`)

    const containerText = document.getElementById(`uned-poll-participa-content-${idNumber[0]}`)
    document.querySelectorAll(".uned-poll-slider-participa-content").forEach(container => container.classList.add('is-disable'))
    document.querySelectorAll(".uned-poll-slider-participa-content").forEach(container => container.classList.remove('is-active'))
    containerText.classList.remove('is-disable')
    containerText.classList.add('is-active')

    document.querySelectorAll(".uned-poll-slider-participa-button-container").forEach(container => container.classList.add('is-disable'))

    if(e.target.classList.contains('is-active-last') && e.target.id !== 'uned-poll-buttons-slider-participa-1') {

      document.querySelectorAll(".uned-poll-slider-participa-button-container").forEach(button => button.classList.remove('is-active-last'))
      buttonBottomActivePrev.classList.remove('is-disable', 'is-active-last')
      buttonBottomActiveNext.classList.remove('is-disable')
      buttonBottomActivePrev.classList.add('is-active', 'is-active-last')
      buttonBottomActiveNext.classList.add('is-active')

    } else if(e.target.id === 'uned-poll-buttons-slider-participa-1') {

      buttonBottomActive.classList.remove('is-disable')
      buttonBottomActiveNext.classList.remove('is-disable')
      buttonBottomActive.classList.add('is-active')
      buttonBottomActiveNext.classList.add('is-active')
      const buttonBottom = document.getElementById(`uned-poll-buttons-slider-participa-${idNumber}`)
      const buttonBottomSibling = document.getElementById(`uned-poll-buttons-slider-participa-${idNumberSiblingNext}`)

      buttonBottom.classList.add('first-button')

    } else if(e.target.id === 'uned-poll-buttons-slider-participa-8') {

      buttonBottomActivePrev.classList.remove('is-disable')
      buttonBottomActive.classList.remove('is-disable')
      buttonBottomActive.classList.add('is-active')
      buttonBottomActivePrev.classList.add('is-active', 'is-active-last')

      const buttonBottom = document.getElementById(`uned-poll-buttons-slider-participa-${idNumber}`)
      buttonBottom.classList.add('last-button')
    } else {
      document.querySelectorAll(".uned-poll-slider-participa-button-container").forEach(button => button.classList.remove('is-active-last'))
      buttonBottomActivePrev.classList.remove('is-disable')
      buttonBottomActivePrev.classList.add('is-active', 'is-active-last')
      buttonBottomActiveNext.classList.remove('is-disable')
      buttonBottomActiveNext.classList.add('is-active')
    }
  }
});
