import React, {useEffect} from 'react';
import { useSelector } from 'react-redux';

export const OptionView = (props) => {

    const question = props.question;
    const index = props.index;
    const showAnswers = useSelector((state) => state.main.showAnswers);

    const getOption = (question) => {

        return question.options.map((option, index) => {
            const selected = question.selectedOptions ? question.selectedOptions[index] : false;
            const correctAnswer = (question.ans.indexOf(option) > -1);

            return <div key={`Q${question.id}OPT${index}`}>
                {selected && !showAnswers && <input id={`Q${question.id}OPT${index}`} type="checkbox" checked value={option} onChange={(event) => props.onChange(event, index)} />}
                {!selected && !showAnswers && <input id={`Q${question.id}OPT${index}`} type="checkbox" value={option} onChange={(event) => props.onChange(event, index)} />}
                {selected && showAnswers && <input id={`Q${question.id}OPT${index}`} type="checkbox" checked disabled value={option} />}
                {!selected && showAnswers && <input id={`Q${question.id}OPT${index}`} type="checkbox" disabled value={option} />}
                {correctAnswer && showAnswers && <label for="index" className="options-label correct">{option}</label>}
                {!correctAnswer && showAnswers && <label for="index" className="options-label wrong">{option}</label>}
                {!showAnswers && <label for="index" className="options-label">{option}</label>}
            </div>
        })
    }

    return question ? <>
        <div className="question" key={question.id}>{`Q${index + 1}: ${question.q}`}{ showAnswers }</div>
        <div className="options">{getOption(question)}</div>
    </> : null;
}

export default OptionView;
