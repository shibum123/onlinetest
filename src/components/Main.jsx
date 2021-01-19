import React, { useState, useEffect } from 'react';
import { questions } from '../data/data.json';
import { useSelector, useDispatch } from 'react-redux';
import { setQuestions, setShowAnswers } from '../reducers/mainReducer';
import { OptionView } from './OptionView';

const Main = () => {

    const dispatch = useDispatch();

    const jsonData = useSelector((state) => (state.main.questions));

    const allQuestions = useSelector((state) => (state.main.filteredQuestions));

    useEffect(() => {
        dispatch(setQuestions(questions))
    }, []);

    let [currentPage, setCurrentPage] = useState(0);
    const showAnswers = useSelector(state => state.main.showAnswers);

    let [score, setScore] = useState(0);
    const [time, setTime] = useState(0);
    const [wrong_array, setWrong_array] = useState([]);

    const onSubmit = (event) => {
        event.preventDefault();
        setWrong_array([]);
        const arr = [];
        allQuestions.map(item => {
            if (item.ans.toString() === getResult(item).toString()) {
                setScore(++score);
            } else {
                arr.push(item.id);
            }
        });
        setWrong_array(arr);
        dispatch(setShowAnswers(true));

    }

    const getResult = (quest) => {
        const result = [];
        if (quest.selectedOptions) {
            quest.selectedOptions.map((item, index) => {
                if (item === true) result.push(quest.options[index]);
            });
        }
        return result;
    }

    const onNext = () => {
        if (currentPage < allQuestions.length - 1) setCurrentPage(++currentPage);
    }

    const onPrev = (event) => {
        event.preventDefault();
        if (currentPage > 0) setCurrentPage(--currentPage);
    }

    const onChange = (event, index) => {
        if (!allQuestions[currentPage].selectedOptions) allQuestions[currentPage].selectedOptions = [];
        allQuestions[currentPage].selectedOptions[index] = event.target.checked
    }

    const getMessage = (score) => {
        const percent = (score / allQuestions.length * 100).toFixed(2);
        if (percent < 50) {
            return 'You score is very poor! Go and Study again Kanishk!'
        } else if (percent < 70) {
            return 'You score is poor! Go and Study again Kanishk!'
        } else if (percent < 80) {
            return 'You score is fair! Go and Study again Kanishk!'
        } else if (percent < 90) {
            return 'You score is good! Study well Kanishk!'
        } else if (percent < 100) {
            return 'You score is very good! Try to get 100% Kanishk!'
        } else if (percent === '100.00') {
            return 'You score is excellent! Good job Kanishk!'
        }
    }

    const downloadJson = () => {
        questions.map(item => {
            item.attempted_count += 1;
            delete item.selectedOptions;
            if(wrong_array.indexOf(item.id) > -1) {
                item.wrong_count += 1;
            }
        })

        const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(questions));
        const downloadAnchorNode = document.createElement('a');
        downloadAnchorNode.setAttribute("href", dataStr);
        downloadAnchorNode.setAttribute("download", "data.json");
        document.body.appendChild(downloadAnchorNode); // required for firefox
        downloadAnchorNode.click();
        downloadAnchorNode.remove();
    }


    return (
        <div className="container">
            {showAnswers && <h1>{getMessage(score)}</h1>}
            {showAnswers && <h1>{`Your score is: ${(score / allQuestions.length * 100).toFixed(2)} %`}</h1>}
            {!showAnswers && (allQuestions.length > 0) && <h3>{`Question ${currentPage + 1} out of ${allQuestions.length}`}</h3>}
            {showAnswers && (allQuestions.length > 0) ? allQuestions.map((question, index) => <OptionView question={question} index={index} />) : <OptionView question={allQuestions[currentPage]} index={currentPage} onChange={onChange} />}
            <div className="buttonContainer">
                <button className={currentPage <= 0 ? 'btn btn-primary disabled' : 'btn btn-primary'} onClick={onPrev}>&lt;&lt;</button>&nbsp;&nbsp;&nbsp;
                <button className={(currentPage < allQuestions.length - 1) ? 'btn btn-primary' : 'btn btn-primary disabled'} onClick={onNext}>&gt;&gt;</button>&nbsp;&nbsp;&nbsp;
                {currentPage === (allQuestions.length - 1) && !showAnswers && <button className="btn btn-primary" onClick={onSubmit}>Submit</button>}&nbsp;&nbsp;&nbsp;
                {showAnswers && <button className={'btn btn-secondary'} onClick={downloadJson}>DOWNLOAD</button>}
            </div>
        </div>
    )
}

export default Main;